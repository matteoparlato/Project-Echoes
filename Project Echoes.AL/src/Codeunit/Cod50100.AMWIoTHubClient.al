codeunit 50100 "AMW IoT Hub Client"
{
    var
        Client: HttpClient;

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    procedure GetClient(): HttpClient
    begin
        exit(Client);
    end;

    /// <summary>
    /// 
    /// </summary>
    /// <param name="SASToken"></param>
    procedure InitializeClient(SASToken: Text)
    begin
        Client.Clear();
        AddRequestHeader('Authorization', SASToken);
    end;

    /// <summary>
    /// 
    /// </summary>
    /// <param name="Name"></param>
    /// <param name="Value"></param>
    procedure AddRequestHeader(Name: Text; Value: Text)
    begin
        Client.DefaultRequestHeaders.Add(Name, Value);
    end;

    /// <summary>
    /// 
    /// </summary>
    /// <param name="HubName"></param>
    /// <returns></returns>
    procedure GetDevices(HubName: Text): Boolean
    var
        Endpoint: Record "AMW IoT Hub Endpoint";
        Device: Record "AMW IoT Device";
        ResponseMessage: HttpResponseMessage;
        ReponseContent: Text;
        JArray: JsonArray;
        JObject: JsonObject;
        JToken: JsonToken;
        JProperty: JsonToken;
    begin
        Endpoint.Get(HubName, Endpoint.Code::DEVICES);

        Client.Get(Endpoint.Uri, ResponseMessage);
        if ResponseMessage.IsSuccessStatusCode() then begin
            Device.Reset();
            Device.SetRange("Hub Name", HubName);
            Device.DeleteAll();

            ResponseMessage.Content().ReadAs(ReponseContent);

            JArray.ReadFrom(ReponseContent);
            foreach JToken in JArray do begin
                Device.init;
                Device."Hub Name" := HubName;

                JObject := JToken.AsObject();
                if JObject.Get('deviceId', JProperty) then
                    Device."Device ID" := JProperty.AsValue().AsText();
                if JObject.Get('connectionState', JProperty) then
                    Device."Connection Status" := JProperty.AsValue().AsText();
                if JObject.Get('status', JProperty) then
                    Device.Status := JProperty.AsValue().AsText();
                if JObject.Get('statusUpdatedTime', JProperty) then
                    Device."Last Status Update Time" := JProperty.AsValue().AsDateTime();

                Device.Insert();
            end;
        end;

        exit(ResponseMessage.IsSuccessStatusCode());
    end;

    /// <summary>
    /// 
    /// </summary>
    /// <param name="HubName"></param>
    /// <returns></returns>
    procedure GetDevicesStatus(HubName: Text): Boolean
    var
        Endpoint: Record "AMW IoT Hub Endpoint";
        Device: Record "AMW IoT Device";
        DeviceID: Text;
        ResponseMessage: HttpResponseMessage;
        ReponseContent: Text;
        JArray: JsonArray;
        JObject: JsonObject;
        JToken: JsonToken;
        JProperty: JsonToken;
    begin
        Endpoint.Get(HubName, Endpoint.Code::DEVICES);

        Client.Get(Endpoint.Uri, ResponseMessage);
        if ResponseMessage.IsSuccessStatusCode() then begin
            Device.Reset();
            Device.SetRange("Hub Name", HubName);
            Device.DeleteAll();

            ResponseMessage.Content().ReadAs(ReponseContent);

            JArray.ReadFrom(ReponseContent);
            foreach JToken in JArray do begin
                Device.init;
                Device."Hub Name" := HubName;

                JObject := JToken.AsObject();
                if JObject.Get('deviceId', JProperty) then
                    if Device.Get(JProperty.AsValue().AsText()) then begin
                        if JObject.Get('connectionState', JProperty) then
                            Device."Connection Status" := JProperty.AsValue().AsText();
                        if JObject.Get('status', JProperty) then
                            Device.Status := JProperty.AsValue().AsText();
                        if JObject.Get('statusUpdatedTime', JProperty) then
                            Device."Last Status Update Time" := JProperty.AsValue().AsDateTime();

                        Device.Modify();
                    end;
            end;
        end;

        exit(ResponseMessage.IsSuccessStatusCode());
    end;

    /// <summary>
    /// 
    /// </summary>
    /// <param name="Device"></param>
    /// <param name="Method"></param>
    /// <param name="Payload"></param>
    /// <returns></returns>
    procedure InvokeMethod(Device: Record "AMW IoT Device"; Method: Text; Payload: Text): Boolean
    var
        Endpoint: Record "AMW IoT Hub Endpoint";
        RemoteUri: Text;
        Content: HttpContent;
        ContentText: Text;
        JObject: JsonObject;
        ResponseMessage: HttpResponseMessage;
    begin
        Endpoint.Get(Device."Hub Name", Endpoint.Code::TWINS_METHODS_INVOKE);

        JObject.Add('connectTimeoutInSeconds', 60);
        JObject.Add('responseTimeoutInSeconds', 60);
        JObject.Add('methodName', Method);
        JObject.Add('payload', Payload);

        JObject.WriteTo(ContentText);
        Content.WriteFrom(ContentText);

        RemoteUri := Endpoint.Uri.Replace('{deviceId}', Device."Device ID");

        Client.Post(RemoteUri, Content, ResponseMessage);

        exit(ResponseMessage.IsSuccessStatusCode());
    end;
}
