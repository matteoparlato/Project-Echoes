page 50104 "AMW IoT Device Telemetry API"
{
    APIGroup = 'iot';
    APIPublisher = 'AMW';
    APIVersion = 'v1.0';
    Caption = 'AMW IoT Device Telemetry API';
    DelayedInsert = true;
    DeleteAllowed = false;
    EntityName = 'telemetry';
    EntitySetName = 'telemetry';
    ModifyAllowed = false;
    PageType = API;
    SourceTable = "AMW IoT Device Telemetry";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.ID)
                {
                    Caption = 'ID';
                }
                field(hubName; Rec."Hub Name")
                {
                    Caption = 'Hub Name';
                }
                field(deviceID; Rec."Device ID")
                {
                    Caption = 'Device ID';
                }
                field(enqueuedDateTime; Rec."Enqueued DateTime")
                {
                    Caption = 'Enqueued Time';
                }
                field(importDateTime; Rec."Import DateTime")
                {
                    Caption = 'Processed Time';
                }
                field("key"; Rec."Key")
                {
                    Caption = 'Key';
                }
                field("value"; Rec."Value")
                {
                    Caption = 'Value';
                }
            }
        }
    }
}
