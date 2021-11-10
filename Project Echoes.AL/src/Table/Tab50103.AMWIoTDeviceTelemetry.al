table 50103 "AMW IoT Device Telemetry"
{
    Caption = 'AMW IoT Device Telemetry';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Guid)
        {
            Caption = 'ID';
            DataClassification = ToBeClassified;
        }
        field(2; "Hub Name"; Text[250])
        {
            Caption = 'Hub Name';
            DataClassification = ToBeClassified;
        }
        field(3; "Device ID"; Text[250])
        {
            Caption = 'Device ID';
            DataClassification = ToBeClassified;
        }
        field(4; "Enqueued DateTime"; DateTime)
        {
            Caption = 'Enqueued Time';
            DataClassification = ToBeClassified;
        }
        field(5; "Import DateTime"; DateTime)
        {
            Caption = 'Processed Time';
            DataClassification = ToBeClassified;
        }
        field(6; "Key"; Text[250])
        {
            Caption = 'Key';
            DataClassification = ToBeClassified;
        }
        field(7; "Value"; Text[250])
        {
            Caption = 'Value';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
        key("Key2"; "Enqueued DateTime")
        {
            //
        }
        key("Key3"; "Import DateTime")
        {
            //
        }
        key("Key4"; "Hub Name", "Device ID")
        {
            //
        }
    }

    trigger OnInsert()
    begin
        ID := CreateGuid();
        "Import DateTime" := CreateDateTime(Today, Time);
    end;
}
