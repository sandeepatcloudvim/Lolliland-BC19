tableextension 54500 LOLI_ExtendItemTemplate extends "Item Templ."
{
    fields
    {
        field(54500; "LOLI_Sales Unit of Measure"; Code[10])
        {
            Caption = 'Sales Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(54501; "LOLI_Purch. Unit of Measure"; Code[10])
        {
            Caption = 'Purch. Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(54502; "LOLI_Put-away Unit of Measure"; Code[10])
        {
            Caption = 'Put-away Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(54503; "LOLI_Bulk Unit of Measure"; Code[10])
        {
            Caption = 'Bulk Unit of Measure';
            TableRelation = "Unit of Measure";
        }

    }


    var
        myInt: Integer;
}