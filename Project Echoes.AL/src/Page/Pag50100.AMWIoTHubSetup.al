page 50100 "AMW IoT Hub Setup"
{
    ApplicationArea = All;
    Caption = 'AMW IoT Hub Setup';
    PageType = Worksheet;
    SourceTable = "AMW IoT Hub Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Host Name"; Rec."Hub Name")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("SAS Key"; Rec."SAS Token")
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                    ShowMandatory = true;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Get Hub Devices")
            {
                ApplicationArea = All;
                Image = BOM;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Service: Codeunit "AMW IoT Hub Client";
                begin
                    Clear(GlobalNotification);

                    Rec.TestField("SAS Token");

                    Service.InitializeClient(Rec."SAS Token");
                    if Service.GetDevices(Rec."Hub Name") then begin
                        GlobalNotification.Message(StrSubstNo(GetHubDevicesSuccessMsg, Rec."Hub Name"));
                        GlobalNotification.AddAction(OpenHubExplorerActionTxt, Codeunit::"AMW IoT Hub Helper", 'OpenHubExplorer');
                    end else
                        GlobalNotification.Message(StrSubstNo(GetHubDevicesErrorMsg, Rec."Hub Name"));
                    GlobalNotification.Send();
                end;
            }

            action("Endpoints")
            {
                ApplicationArea = All;
                Image = ExchProdBOMItem;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    HubEndpoints: Page "AMW IoT Hub Endpoints";
                begin
                    Rec.TestField("Hub Name");
                    HubEndpoints.SetHubName(Rec."Hub Name");
                    HubEndpoints.RunModal();
                end;
            }
        }
    }

    var
        GlobalNotification: Notification;
        GetHubDevicesSuccessMsg: Label 'Successfully retrieved devices information from %1!';
        OpenHubExplorerActionTxt: Label 'Open Hub Explorer';
        GetHubDevicesErrorMsg: Label 'An error occured while contacting %1. Please check if the provided SAS token is still valid.';
}
