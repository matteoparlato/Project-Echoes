page 50102 "AMW Direct Method List"
{
    
    ApplicationArea = All;
    Caption = 'AMW Direct Method List';
    PageType = List;
    SourceTable = "AMW Direct Method";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    
}
