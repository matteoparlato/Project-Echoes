table 50100 "AMW IoT Hub"
{
    Caption = 'AMW IoT Hub';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Host Name"; Text[250])
        {
            Caption = 'Host Name';
            DataClassification = ToBeClassified;
        }
        field(2; "SAS Key"; Text[250])
        {
            Caption = 'SAS Key';
            DataClassification = ToBeClassified;
        }
        field(3; "Connection String"; Text[250])
        {
            Caption = 'Connection String';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Host Name")
        {
            Clustered = true;
        }
    }
    
}
