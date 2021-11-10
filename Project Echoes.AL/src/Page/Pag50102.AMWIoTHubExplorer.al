page 50102 "AMW IoT Hub Explorer"
{
    ApplicationArea = All;
    Caption = 'AMW IoT Hub Explorer';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    ShowFilter = false;
    SourceTable = "AMW IoT Device";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = false;
                field(HubNamee; GlobalHubName)
                {
                    ApplicationArea = All;
                    Caption = 'Hub Name';
                    Lookup = true;
                    TableRelation = "AMW IoT Hub Setup";

                    trigger OnAfterLookup(Selected: RecordRef)
                    var
                        Hub: Record "AMW IoT Hub Setup";
                    begin
                        Selected.SetTable(Hub);

                        SetPageFilter(Hub."Hub Name");
                    end;
                }
            }
            repeater(Data)
            {
                field("Hub Name"; Rec."Hub Name")
                {
                    ApplicationArea = All;
                }
                field("Device ID"; Rec."Device ID")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Connection Status"; Rec."Connection Status")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleExpression;
                }
                field("Last Status Update Time"; Rec."Last Status Update Time")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Get Devices")
            {
                ApplicationArea = All;
                Image = BOM;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Hub: Record "AMW IoT Hub Setup";
                    Service: Codeunit "AMW IoT Hub Client";
                begin
                    Clear(GlobalNotification);

                    Hub.Get(GlobalHubName);
                    Hub.TestField("SAS Token");

                    Service.InitializeClient(Hub."SAS Token");
                    if Service.GetDevices(Rec."Hub Name") then begin
                        GlobalNotification.Message(StrSubstNo(GetHubDevicesSuccessMsg, Rec."Hub Name"));
                    end else
                        GlobalNotification.Message(StrSubstNo(ServiceErrorMsg, Rec."Hub Name"));
                    GlobalNotification.Send();
                end;
            }
            action("Telemetry")
            {
                ApplicationArea = All;
                Image = BOMRegisters;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    DeviceTelemetry: Record "AMW IoT Device Telemetry";
                    DeviceTelemetries: Page "AMW IoT Device Telemetries";
                begin
                    DeviceTelemetry.SetRange("Hub Name", Rec."Hub Name");
                    DeviceTelemetry.SetRange("Device ID", Rec."Device ID");
                    DeviceTelemetries.SetTableView(DeviceTelemetry);
                    DeviceTelemetries.Run();
                end;
            }
            action("Direct Method")
            {
                ApplicationArea = All;
                Image = Action;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    InvokeDirectMethod: Page "AMW IoT Direct Method";
                begin
                    InvokeDirectMethod.SetDevice(Rec);
                    InvokeDirectMethod.Run();
                end;
            }
        }
    }

    var
        GlobalHubName: Text;
        GlobalNotification: Notification;
        StyleExpression: Text;
        MissingSetupMsg: Label 'No Azure IoT Hub has been configured yet.';
        MissingSetupActionMsg: Label 'Configure Hub';
        GetHubDevicesSuccessMsg: Label 'Successfully retrieved devices information from %1!';
        ServiceErrorMsg: Label 'An error occured while contacting %1. Please check if the provided SAS token is still valid.';


    trigger OnOpenPage()
    var
        Hub: Record "AMW IoT Hub Setup";
    begin
        Clear(GlobalNotification);

        if Hub.FindFirst() then
            SetPageFilter(Hub."Hub Name")
        else begin
            GlobalNotification.Message(MissingSetupMsg);
            GlobalNotification.AddAction(MissingSetupActionMsg, Codeunit::"AMW IoT Hub Helper", 'OpenHubSetup');
            GlobalNotification.Send();
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Connection Status" = 'Connected' then
            StyleExpression := 'Favorable'
        else
            StyleExpression := 'Unfavorable';
    end;

    local procedure SetPageFilter(HubName: Text)
    begin
        GlobalHubName := HubName;

        Rec.FilterGroup(2);
        Rec.SetRange("Hub Name", HubName);
        Rec.FilterGroup(0);

        CurrPage.Update();
    end;
}
