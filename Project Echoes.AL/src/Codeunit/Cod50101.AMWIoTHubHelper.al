codeunit 50101 "AMW IoT Hub Helper"
{
    /// <summary>
    /// 
    /// </summary>
    /// <param name="Hub"></param>
    procedure InitializeHub(Hub: Record "AMW IoT Hub Setup")
    begin
        SetDefaultEndpoints(Hub."Hub Name");
    end;

    /// <summary>
    /// 
    /// </summary>
    /// <param name="HubName"></param>
    procedure SetDefaultEndpoints(HubName: Text)
    var
        Endpoint: Record "AMW IoT Hub Endpoint";
    begin
        Endpoint.Reset();
        Endpoint.SetRange("Hub Name", HubName);
        Endpoint.DeleteAll();

        AddEndpoint(HubName, Endpoint.Code::DEVICES, 'https://fully-qualified-iothubname.azure-devices.net/devices?api-version=2020-05-31-preview');
        AddEndpoint(HubName, Endpoint.Code::TWINS_METHODS_INVOKE, 'https://fully-qualified-iothubname.azure-devices.net/twins/{deviceId}/methods?api-version=2020-05-31-preview');
    end;

    /// <summary>
    /// 
    /// </summary>
    /// <param name="HubName"></param>
    /// <param name="Code"></param>
    /// <param name="Uri"></param>
    procedure AddEndpoint(HubName: Text; Code: Option; Uri: Text)
    var
        Endpoint: Record "AMW IoT Hub Endpoint";
    begin
        Endpoint.Init();
        Endpoint."Hub Name" := HubName;
        Endpoint.Code := Code;
        Endpoint.Uri := Uri.Replace('fully-qualified-iothubname', HubName);
        Endpoint.Insert();
    end;

    /// <summary>
    /// 
    /// </summary>
    /// <param name="NotificationContext"></param>
    procedure OpenHubExplorer(NotificationContext: Notification)
    begin
        Page.Run(Page::"AMW IoT Hub Explorer");
    end;
}
