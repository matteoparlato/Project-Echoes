page 50103 "AMW IoT Device Method List"
{
    
    Caption = 'AMW IoT Device Method List';
    PageType = List;
    SourceTable = "AMW IoT Device Method";
    
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
                field(Method; Rec.Method)
                {
                    ToolTip = 'Specifies the value of the Method field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    
}
