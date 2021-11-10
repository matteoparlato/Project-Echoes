page 50101 "AMW IoT Hub Endpoints"
{
    Caption = 'Hub Endpoints';
    LinksAllowed = false;
    PageType = Worksheet;
    ShowFilter = false;
    SourceTable = "AMW IoT Hub Endpoint";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Hub Name"; Rec."Hub Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field(Uri; Rec.Uri)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Set Defaults")
            {
                ApplicationArea = All;
                Image = Restore;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Helper: Codeunit "AMW IoT Hub Helper";
                begin
                    Helper.SetDefaultEndpoints(GlobalHubName);
                end;
            }
        }
        area(Navigation)
        {
            action("Logs")
            {
                ApplicationArea = All;
                Image = Log;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ActivityLog: Record "Activity Log";
                begin
                    ActivityLog.ShowEntries(Rec);
                end;
            }
        }
    }

    var
        GlobalHubName: Text;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Hub Name" := GlobalHubName;
    end;

    procedure SetHubName(HubName: Text)
    begin
        GlobalHubName := HubName;
    end;
}
