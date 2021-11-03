table 50103 "AMW IoT Device Method"
{
    Caption = 'AMW IoT Device Method';
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
        field(3; Method; Text[250])
        {
            Caption = 'Method';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Host Name", "Device ID", "Method")
        {
            Clustered = true;
        }
    }

}
