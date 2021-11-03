table 50102 "AMW Direct Method"
{
    Caption = 'AMW Direct Method';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Name; Text[250])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }

}
