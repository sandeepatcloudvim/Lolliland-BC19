pageextension 54505 ExtendCustomerList extends "Customer List"
{
    layout
    {

    }

    actions
    {
        addafter("ePDF Customer Statement")
        {
            action("LOLI_CustomerStatement")
            {
                ApplicationArea = All;
                Caption = 'Customer Statement - Lolliland';
                Image = SalesTaxStatement;
                PromotedCategory = Category7;
                Promoted = true;
                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    Report.Run(54501, true, false, Rec);
                end;
            }
        }
        modify("ePDF Customer Statement")
        {
            ApplicationArea = All;
            Visible = false;
        }
    }

    var
        myInt: Integer;
}