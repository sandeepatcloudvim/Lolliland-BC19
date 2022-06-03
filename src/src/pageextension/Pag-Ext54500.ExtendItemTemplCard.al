pageextension 54500 "ExtendItemTemplCard" extends "Item Templ. Card"
{
    layout
    {
        addafter("Base Unit of Measure")
        {
            field("Sales Unit of Measure"; Rec."LOLI_Sales Unit of Measure")
            {
                ApplicationArea = All;
                Caption = 'Sales Unit of Measure';
            }
            field("Purch. Unit of Measure"; Rec."LOLI_Purch. Unit of Measure")
            {
                ApplicationArea = All;
                Caption = 'Purch. Unit of Measure';
            }


        }

        addafter("Put-away Template Code")
        {
            field("Put-away Unit of Measure Code"; Rec."LOLI_Put-away Unit of Measure")
            {
                ApplicationArea = All;
                Caption = 'Put-away Unit of Measure Code';
            }

            field("Bulk Unit of Measure"; Rec."LOLI_Bulk Unit of Measure")
            {
                ApplicationArea = All;
                Caption = 'Bulk Unit of Measure';
            }
        }
        modify("Warehouse Class Code")
        {
            ApplicationArea = All;
            Visible = true;
        }
        modify("Country/Region of Origin Code")
        {
            ApplicationArea = All;
            Visible = true;
        }
        modify("Reordering Policy")
        {
            ApplicationArea = All;
            Visible = true;
        }
        modify("Put-away Template Code")
        {
            ApplicationArea = All;
            Visible = true;
        }
        modify("Order Tracking Policy")
        {
            ApplicationArea = All;
            Visible = true;
        }


    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;


}