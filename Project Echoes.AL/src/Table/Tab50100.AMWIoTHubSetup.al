table 50100 "AMW IoT Hub Setup"
{
    Caption = 'AMW IoT Hub Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Hub Name"; Text[250])
        {
            Caption = 'Hub Name';
            DataClassification = ToBeClassified;
        }
        field(2; "SAS Token"; Text[250])
        {
            Caption = 'SAS Token';
            DataClassification = ToBeClassified;
        }
        field(3; "Enable Log"; Boolean)
        {
            Caption = 'Enable Log';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Hub Name")
        {
            Clustered = true;
        }
    }
}
