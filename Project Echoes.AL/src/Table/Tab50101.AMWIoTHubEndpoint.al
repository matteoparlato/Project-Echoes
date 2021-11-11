table 50101 "AMW IoT Hub Endpoint"
{
    Caption = 'AMW IoT Hub Endpoint';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Hub Name"; Text[250])
        {
            Caption = 'Hub Name';
            TableRelation = "AMW IoT Device"."Hub Name";
            DataClassification = ToBeClassified;
        }
        field(2; "Code"; Enum "AMW IoT Hub Endpoints")
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(3; Uri; Text[250])
        {
            Caption = 'Uri';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Hub Name", "Code")
        {
            Clustered = true;
        }
    }
}
