table 50102 "AMW IoT Device"
{
    Caption = 'AMW IoT Device';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Hub Name"; Text[250])
        {
            Caption = 'Hub Name';
            TableRelation = "AMW IoT Hub Setup"."Hub Name";
            DataClassification = ToBeClassified;
        }
        field(2; "Device ID"; Text[250])
        {
            Caption = 'Device ID';
            DataClassification = ToBeClassified;
        }
        field(3; Status; Text[30])
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
        }
        field(4; "Connection Status"; Text[30])
        {
            Caption = 'Connection Status';
            DataClassification = ToBeClassified;
        }
        field(5; "Last Status Update Time"; DateTime)
        {
            Caption = 'Last Status Update Time';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Hub Name", "Device ID")
        {
            Clustered = true;
        }
    }
}
