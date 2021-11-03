page 50100 "AMW IoT Hub List"
{
    
    ApplicationArea = All;
    Caption = 'AMW IoT Hub List';
    PageType = List;
    SourceTable = "AMW IoT Hub";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Host Name"; Rec."Host Name")
                {
                    ToolTip = 'Specifies the value of the Host Name field.';
                    ApplicationArea = All;
                }
                field("SAS Key"; Rec."SAS Key")
                {
                    ToolTip = 'Specifies the value of the SAS Key field.';
                    ApplicationArea = All;
                }
                field("Connection String"; Rec."Connection String")
                {
                    ToolTip = 'Specifies the value of the Connection String field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    
}
