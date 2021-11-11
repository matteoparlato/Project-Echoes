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
        field(3; "Generation ID"; Text[50])
        {
            Caption = 'Device ID';
            DataClassification = ToBeClassified;
        }
        field(4; Status; Text[30])
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
        }
        field(5; "Connection Status"; Text[30])
        {
            Caption = 'Connection Status';
            DataClassification = ToBeClassified;
        }
        field(6; "Last Status Update DateTime"; DateTime)
        {
            Caption = 'Last Status Update DateTime';
            DataClassification = ToBeClassified;
        }
        field(7; "Last Activity DateTime"; DateTime)
        {
            Caption = 'Last Activity DateTime';
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
