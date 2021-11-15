codeunit 50101 "AMW IoT Hub Helper"
{
    var
        ConfirmDeletingEntriesQst: Label 'Are you sure that you want to delete log entries?';
        DeletingMsg: Label 'Deleting Entries...';
        DeletedMsg: Label 'The entries were deleted from the log.';

    /// <summary>
    /// Procedure called before inserting a new hub.
    /// Checks required parameters and inserts default endpoints.
    /// </summary>
    /// <param name="Rec">The table record that raises the event</param>
    /// <param name="RunTrigger">Specifies whether to execute the code in the event trigger when it is invoked</param>
    [EventSubscriber(ObjectType::Table, Database::"AMW IoT Hub Setup", 'OnBeforeInsertEvent', '', true, true)]
    local procedure AMWIoTHubSetup_OnBeforeInsertEvent_InitializeHub(var Rec: Record "AMW IoT Hub Setup"; RunTrigger: Boolean)
    begin
        Rec.TestField("Hub Name");
        Rec.TestField("SAS Token");
        SetDefaultEndpoints(Rec."Hub Name");
    end;

    /// <summary>
    /// Procedure called after deleting a hub.
    /// Removes all hub endpoints, devices and device telemetry entries.
    /// </summary>
    /// <param name="Rec">The table record that raises the event</param>
    /// <param name="RunTrigger">Specifies whether to execute the code in the event trigger when it is invoked</param>
    [EventSubscriber(ObjectType::Table, Database::"AMW IoT Hub Setup", 'OnAfterDeleteEvent', '', true, true)]
    local procedure AMWIoTHubSetup_OnAfterDeleteEvent(var Rec: Record "AMW IoT Hub Setup"; RunTrigger: Boolean)
    var
        Endpoint: Record "AMW IoT Hub Endpoint";
        Device: Record "AMW IoT Device";
        Telemetry: Record "AMW IoT Device Telemetry";
    begin
        Endpoint.Reset();
        Endpoint.SetRange("Hub Name", Rec."Hub Name");
        Endpoint.DeleteAll();

        Device.Reset();
        Device.SetRange("Hub Name", Rec."Hub Name");
        Device.DeleteAll();

        Telemetry.Reset();
        Telemetry.SetRange("Hub Name", Rec."Hub Name");
        Telemetry.DeleteAll();
    end;

    /// <summary>
    /// Procedure which inserts default hub endpoints.
    /// </summary>
    /// <param name="HubName">The name of the hub the endpoint should point to</param>
    procedure SetDefaultEndpoints(HubName: Text)
    var
        Endpoint: Record "AMW IoT Hub Endpoint";
    begin
        Endpoint.Reset();
        Endpoint.SetRange("Hub Name", HubName);
        Endpoint.DeleteAll();

        AddEndpoint(HubName, Endpoint.Code::DEVICES.AsInteger(), 'https://fully-qualified-iothubname.azure-devices.net/devices?api-version=2020-05-31-preview');
        AddEndpoint(HubName, Endpoint.Code::TWINS_METHODS_INVOKE.AsInteger(), 'https://fully-qualified-iothubname.azure-devices.net/twins/{deviceId}/methods?api-version=2020-05-31-preview');

        OnAfterInsertDefaultEndpoints(HubName);
    end;

    /// <summary>
    /// Procedure which inserts a new hub endpoint.
    /// </summary>
    /// <param name="HubName">The name of the hub the endpoint should point to</param>
    /// <param name="Code">The name of the endpoint</param>
    /// <param name="Uri">The uri of the endpoint</param>
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
    /// Procedure which deletes device telemetry entries.
    /// </summary>
    /// <param name="DaysOld">The number of days to delete</param>
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
    /// Procedure invoked from Notification action.
    /// Opens "AMW IoT Hub Setup" page.
    /// </summary>
    /// <param name="NotificationContext">The notification on which the action was invoked</param>
    procedure OpenHubSetup(NotificationContext: Notification)
    begin
        Page.Run(Page::"AMW IoT Hub Setup");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertDefaultEndpoints(HubName: Text)
    begin
    end;
}
