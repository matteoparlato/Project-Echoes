codeunit 50101 "AMW IoT Hub Helper"
{
    var
        ConfirmDeletingEntriesQst: Label 'Are you sure that you want to delete log entries?';
        DeletingMsg: Label 'Deleting Entries...';
        DeletedMsg: Label 'The entries were deleted from the log.';

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

        AddEndpoint(HubName, Endpoint.Code::DEVICES.AsInteger(), 'https://fully-qualified-iothubname.azure-devices.net/devices?api-version=2020-05-31-preview');
        AddEndpoint(HubName, Endpoint.Code::TWINS_METHODS_INVOKE.AsInteger(), 'https://fully-qualified-iothubname.azure-devices.net/twins/{deviceId}/methods?api-version=2020-05-31-preview');
    end;

    /// <summary>
    /// 
    /// </summary>
    /// <param name="HubName"></param>
    /// <param name="Code"></param>
    /// <param name="Uri"></param>
    procedure AddEndpoint(HubName: Text; Code: Integer; Uri: Text)
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
    /// <param name="DaysOld"></param>
    procedure DeleteTelemetryEntries(DaysOld: Integer)
    var
        Window: Dialog;
        DeviceTelemetry: Record "AMW IoT Device Telemetry";
    begin
        if GuiAllowed then begin
            if not Confirm(ConfirmDeletingEntriesQst) then
                exit;

            Window.Open(DeletingMsg);
        end;

        if DaysOld > 0 then
            DeviceTelemetry.SetFilter("Import DateTime", '<=%1', CreateDateTime(Today - DaysOld, Time));

        DeviceTelemetry.DeleteAll();

        if GuiAllowed then begin
            Window.Close;

            Message(DeletedMsg);
        end;
    end;

    /// <summary>
    /// 
    /// </summary>
    /// <param name="NotificationContext"></param>
    procedure OpenHubSetup(NotificationContext: Notification)
    begin
        Page.Run(Page::"AMW IoT Hub Setup");
    end;
}
