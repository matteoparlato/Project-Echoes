table 50101 "AMW IoT Device"
{
    Caption = 'AMW IoT Device';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Host Name"; Text[250])
        {
            Caption = 'Host Name';
            DataClassification = ToBeClassified;
        }
        field(2; "Device ID"; Text[250])
        {
            Caption = 'Device ID';
            DataClassification = ToBeClassified;
        }
        field(3; Status; Boolean)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
        }
        field(4; "Connection Status"; Text[30])
        {
            Caption = 'Connection Status';
            DataClassification = ToBeClassified;
        }
        field(5; Authentication; Text[30])
        {
            Caption = 'Authentication';
            DataClassification = ToBeClassified;
        }
        field(6; "Last Status Update Time"; DateTime)
        {
            Caption = 'Last Status Update Time';
            DataClassification = ToBeClassified;
        }
        field(7; "IoT Plug And Play Device"; Text[250])
        {
            Caption = 'IoT Plug And Play Device';
            DataClassification = ToBeClassified;
        }
        field(8; "Edge Device"; Text[250])
        {
            Caption = 'Edge Device';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Host Name", "Device ID")
        {
            Clustered = true;
        }
    }

}
