page 50105 "AMW IoT Device Telemetries"
{
    Caption = 'Device Telemetries';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SourceTable = "AMW IoT Device Telemetry";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Hub Name"; Rec."Hub Name")
                {
                    ApplicationArea = All;
                }
                field("Device ID"; Rec."Device ID")
                {
                    ApplicationArea = All;
                }
                field("Enqueued DateTime"; Rec."Enqueued DateTime")
                {
                    ApplicationArea = All;
                }
                field("Import DateTime"; Rec."Import DateTime")
                {
                    ApplicationArea = All;
                }
                field(Payload; Rec.Payload)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Delete7days)
            {
                ApplicationArea = All;
                Caption = 'Delete Entries Older Than 7 Days';
                Image = ClearLog;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Removes entries that are older than 7 days from the log.';

                trigger OnAction()
                var
                    Helper: Codeunit "AMW IoT Hub Helper";
                begin
                    Helper.DeleteTelemetryEntries(7);
                end;
            }
            action(Delete0days)
            {
                ApplicationArea = All;
                Caption = 'Delete All Entries';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Empties the log. All entries will be deleted.';

                trigger OnAction()
                var
                    Helper: Codeunit "AMW IoT Hub Helper";
                begin
                    Helper.DeleteTelemetryEntries(0);
                end;
            }
        }
    }
}
