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
        Hub: Record "AMW IoT Hub Setup";
        Endpoint: Record "AMW IoT Hub Endpoint";
        Device: Record "AMW IoT Device";
        ResponseMessage: HttpResponseMessage;
        ReponseContent: Text;
        JArray: JsonArray;
        JObject: JsonObject;
        JToken: JsonToken;
        JProperty: JsonToken;
    begin
        Hub.Get(HubName);
        Endpoint.Get(HubName, Endpoint.Code::DEVICES);

        if Hub."Enable Log" then
            LogServiceEvent(Endpoint, '');

        Client.Get(Endpoint.Uri, ResponseMessage);

        if Hub."Enable Log" then
            LogServiceEvent(Endpoint, ResponseMessage);

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
                if JObject.Get('generationId', JProperty) then
                    Device."Generation ID" := JProperty.AsValue().AsText();
                if JObject.Get('connectionState', JProperty) then
                    Device."Connection Status" := JProperty.AsValue().AsText();
                if JObject.Get('status', JProperty) then
                    Device.Status := JProperty.AsValue().AsText();
                if JObject.Get('connectionStateUpdatedTime', JProperty) then
                    Device."Last Status Update DateTime" := JProperty.AsValue().AsDateTime();
                if JObject.Get('lastActivityTime', JProperty) then
                    Device."Last Activity DateTime" := JProperty.AsValue().AsDateTime();

                Device.Insert();
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
        Hub: Record "AMW IoT Hub Setup";
        Endpoint: Record "AMW IoT Hub Endpoint";
        Uri: Text;
        Content: HttpContent;
        ContentText: Text;
        JObject: JsonObject;
        ResponseMessage: HttpResponseMessage;
    begin
        Hub.Get(Device."Hub Name");
        Endpoint.Get(Device."Hub Name", Endpoint.Code::TWINS_METHODS_INVOKE);

        JObject.Add('connectTimeoutInSeconds', 60);
        JObject.Add('responseTimeoutInSeconds', 60);
        JObject.Add('methodName', Method);
        JObject.Add('payload', Payload);

        JObject.WriteTo(ContentText);
        Content.WriteFrom(ContentText);

        Uri := Endpoint.Uri.Replace('{deviceId}', Device."Device ID");

        if Hub."Enable Log" then
            LogServiceEvent(Endpoint, ContentText);

        Client.Post(Uri, Content, ResponseMessage);

        if Hub."Enable Log" then
            LogServiceEvent(Endpoint, ResponseMessage);

        exit(ResponseMessage.IsSuccessStatusCode());
    end;

    /// <summary>
    /// 
    /// </summary>
    /// <param name="Endpoint"></param>
    /// <param name="Uri"></param>
    /// <param name="Content"></param>
    local procedure LogServiceEvent(Endpoint: Record "AMW IoT Hub Endpoint"; Content: Text)
    var
        ActivityLog: Record "Activity Log";
    begin
        ActivityLog.LogActivity(Endpoint, ActivityLog.Status::Success, 'AMW_AZ_IOT_HUB_REQUEST', Endpoint.Uri, Content);
    end;

    /// <summary>
    /// 
    /// </summary>
    /// <param name="Endpoint"></param>
    /// <param name="RequestMessage"></param>
    local procedure LogServiceEvent(Endpoint: Record "AMW IoT Hub Endpoint"; RequestMessage: HttpRequestMessage)
    var
        ActivityLog: Record "Activity Log";
        ContentText: Text;
    begin
        RequestMessage.Content.ReadAs(ContentText);
        ActivityLog.LogActivity(Endpoint, ActivityLog.Status::Success, 'AMW_AZ_IOT_HUB_REQUEST', RequestMessage.GetRequestUri(), ContentText);
    end;

    /// <summary>
    /// 
    /// </summary>
    /// <param name="Endpoint"></param>
    /// <param name="ResponseMessage"></param>
    local procedure LogServiceEvent(Endpoint: Record "AMW IoT Hub Endpoint"; ResponseMessage: HttpResponseMessage)
    var
        ActivityLog: Record "Activity Log";
        ContentText: Text;
    begin
        ResponseMessage.Content.ReadAs(ContentText);
        ActivityLog.LogActivity(Endpoint, ActivityLog.Status::Success, 'AMW_AZ_IOT_HUB_RESPONSE', Format(ResponseMessage.HttpStatusCode), ContentText);
    end;
}