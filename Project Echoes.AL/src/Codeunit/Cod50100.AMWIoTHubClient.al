codeunit 50100 "AMW IoT Hub Client"
{
    var
        Client: HttpClient;

    /// <summary>
    /// Procedure which returns an HttpClient instance.
    /// </summary>
    /// <returns>An HttpClient instance</returns>
    procedure GetClient(): HttpClient
    begin
        exit(Client);
    end;

    /// <summary>
    /// Procedure which initializes the HttpClient with the provided parameters.
    /// </summary>
    /// <param name="SASToken">The SAS token to add as Authorization header</param>
    procedure InitializeClient(SASToken: Text)
    begin
        Client.Clear();
        AddRequestHeader('Authorization', SASToken);
    end;

    /// <summary>
    /// Procedure which adds a request header to the HttpClient.
    /// </summary>
    /// <param name="Name"></param>
    /// <param name="Value"></param>
    procedure AddRequestHeader(Name: Text; Value: Text)
    begin
        Client.DefaultRequestHeaders.Add(Name, Value);
    end;

    /// <summary>
    /// Procedure which gets the identities of multiple devices from the IoT Hub identity registry.
    /// </summary>
    /// <param name="HubName">The name of the hub to query</param>
    /// <returns>A value that indicates if the HTTP response was successful</returns>
    procedure GetDevices(HubName: Text): Boolean
    var
        Hub: Record "AMW IoT Hub Setup";
        Endpoint: Record "AMW IoT Hub Endpoint";
        Device: Record "AMW IoT Device";
        Handled: Boolean;
        ResponseMessage: HttpResponseMessage;
        ReponseContent: Text;
        JArray: JsonArray;
        JObject: JsonObject;
        JToken: JsonToken;
        JProperty: JsonToken;
    begin
        Hub.Get(HubName);
        Endpoint.Get(HubName, Endpoint.Code::DEVICES);

        OnBeforeGetDevices(Hub, Endpoint, Device, ResponseMessage, Handled);
        if Handled then
            exit(ResponseMessage.IsSuccessStatusCode);

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
    /// Procedure which invokes a direct method on a device.
    /// </summary>
    /// <param name="Device">The device where to invoke the method</param>
    /// <param name="Method">The name of the method to invoke</param>
    /// <param name="Payload">The payload of the method</param>
    /// <returns>A value that indicates if the HTTP response was successful</returns>
    procedure InvokeMethod(Device: Record "AMW IoT Device"; Method: Text; Payload: Text): Boolean
    var
        Hub: Record "AMW IoT Hub Setup";
        Endpoint: Record "AMW IoT Hub Endpoint";
        Handled: Boolean;
        Uri: Text;
        Content: HttpContent;
        ContentText: Text;
        JObject: JsonObject;
        ResponseMessage: HttpResponseMessage;
    begin
        Hub.Get(Device."Hub Name");
        Endpoint.Get(Device."Hub Name", Endpoint.Code::TWINS_METHODS_INVOKE);

        OnBeforeInvokeMethod(Hub, Endpoint, Method, Payload, ResponseMessage, Handled);
        if Handled then
            exit(ResponseMessage.IsSuccessStatusCode);

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
    /// Procedure which logs HttpClient request details.
    /// </summary>
    /// <param name="Endpoint">The endpoint called by the HttpClient</param>
    /// <param name="Content">The content of the request sent by the HttpClient</param>
    local procedure LogServiceEvent(Endpoint: Record "AMW IoT Hub Endpoint"; Content: Text)
    var
        ActivityLog: Record "Activity Log";
    begin
        ActivityLog.LogActivity(Endpoint, ActivityLog.Status::Success, 'AMW_AZ_IOT_HUB_REQUEST', Endpoint.Uri, Content);
    end;

    /// <summary>
    /// Procedure which logs HttpClient request details.
    /// </summary>
    /// <param name="Endpoint">The endpoint called by HttpClient</param>
    /// <param name="RequestMessage">The request message sent by the HttpClient</param>
    local procedure LogServiceEvent(Endpoint: Record "AMW IoT Hub Endpoint"; RequestMessage: HttpRequestMessage)
    var
        ActivityLog: Record "Activity Log";
        ContentText: Text;
    begin
        RequestMessage.Content.ReadAs(ContentText);
        ActivityLog.LogActivity(Endpoint, ActivityLog.Status::Success, 'AMW_AZ_IOT_HUB_REQUEST', RequestMessage.GetRequestUri(), ContentText);
    end;

    /// <summary>
    /// Procedure which logs HttpClient response details.
    /// </summary>
    /// <param name="Endpoint">The endpoint called by HttpClient</param>
    /// <param name="ResponseMessage">The response message received from the HttpClient</param>
    local procedure LogServiceEvent(Endpoint: Record "AMW IoT Hub Endpoint"; ResponseMessage: HttpResponseMessage)
    var
        ActivityLog: Record "Activity Log";
        ContentText: Text;
    begin
        ResponseMessage.Content.ReadAs(ContentText);
        ActivityLog.LogActivity(Endpoint, ActivityLog.Status::Success, 'AMW_AZ_IOT_HUB_RESPONSE', Format(ResponseMessage.HttpStatusCode), ContentText);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetDevices(Hub: Record "AMW IoT Hub Setup"; Endpoint: Record "AMW IoT Hub Endpoint"; Device: Record "AMW IoT Device"; var ResponseMessage: HttpResponseMessage; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInvokeMethod(Hub: Record "AMW IoT Hub Setup"; Endpoint: Record "AMW IoT Hub Endpoint"; Method: Text; Payload: Text; ResponseMessage: HttpResponseMessage; Handled: Boolean)
    begin
    end;
}