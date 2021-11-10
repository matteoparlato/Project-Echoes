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
                field(HubName; HubName)
                {
                    ApplicationArea = All;
                    Caption = 'Hub Name';
                    Lookup = true;
                    TableRelation = "AMW IoT Hub Setup";

                    trigger OnAfterLookup(Selected: RecordRef)
                    begin

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
            action("Invoke Direct Method")
            {
                ApplicationArea = All;
                Image = Action;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    InvokeDirectMethod: Page "AMW Invoke Direct Method Card";
                begin
                    InvokeDirectMethod.SetDevice(Rec);
                    InvokeDirectMethod.Run();
                end;
            }
        }
    }

    var
        HubName: Text;
        StyleExpression: Text;

    trigger OnAfterGetRecord()
    begin
        if Rec."Connection Status" = 'Connected' then
            StyleExpression := 'Favorable'
        else
            StyleExpression := 'Unfavorable';
    end;
}
