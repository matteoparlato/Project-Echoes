page 50100 "AMW IoT Hub Setup"
{
    ApplicationArea = All;
    Caption = 'AMW IoT Hub Setup';
    DelayedInsert = true;
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
                field("Enable Log"; Rec."Enable Log")
                {
                    ApplicationArea = All;
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
}
