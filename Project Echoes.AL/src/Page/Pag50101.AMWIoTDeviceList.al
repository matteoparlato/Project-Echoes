page 50101 "AMW IoT Device List"
{
    
    Caption = 'AMW IoT Device List';
    PageType = List;
    SourceTable = "AMW IoT Device";
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Device ID"; Rec."Device ID")
                {
                    ToolTip = 'Specifies the value of the Device ID field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field("Connection Status"; Rec."Connection Status")
                {
                    ToolTip = 'Specifies the value of the Connection Status field.';
                    ApplicationArea = All;
                }
                field(Authentication; Rec.Authentication)
                {
                    ToolTip = 'Specifies the value of the Authentication field.';
                    ApplicationArea = All;
                }
                field("Last Status Update Time"; Rec."Last Status Update Time")
                {
                    ToolTip = 'Specifies the value of the Last Status Update Time field.';
                    ApplicationArea = All;
                }
                field("IoT Plug And Play Device"; Rec."IoT Plug And Play Device")
                {
                    ToolTip = 'Specifies the value of the IoT Plug And Play Device field.';
                    ApplicationArea = All;
                }
                field("Edge Device"; Rec."Edge Device")
                {
                    ToolTip = 'Specifies the value of the Edge Device field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    
}
