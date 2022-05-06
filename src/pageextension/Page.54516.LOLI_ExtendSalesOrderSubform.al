pageextension 54516 "LOLI_SalesOrderSubform" extends "Sales Order Subform"
{
    layout
    {
        addafter("Location Code")
        {
            field("ReturnReasonCode"; Rec."Return Reason Code")
            {
                ApplicationArea = All;
                Caption = 'Reason Code';
            }
        }
        // modify(Quantity)
        // {
        //     ApplicationArea = All;
        //     trigger OnAfterValidate()
        //     var
        //         ReturnReason: Record "Return Reason";
        //         ReturnReasonList: Page "Return Reasons";
        //         SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
        //     begin

        //         if rec.Quantity > 0 then begin
        //             Commit();
        //             if SalesInfoPaneMgt.CalcAvailability(Rec) <= 0 then begin
        //                 ReturnReason.Reset();
        //                 ReturnReason.SetFilter(Code, '%1', 'OOS*');
        //                 if Page.RunModal(Page::"Return Reasons", ReturnReason) = Action::LookupOK then begin
        //                     Rec."Return Reason Code" := ReturnReason.Code;
        //                     Rec.Modify();
        //                 end;
        //             end;
        //         end;
        //     end;
        //}
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}