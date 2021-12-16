pageextension 54503 "LOLI_ExtendSalesOrderList" extends "Sales Order List"
{
    layout
    {
        addafter("Posting Date")
        {
            field("LOLI Adjusted Profit Amt"; Rec."LOLI_Adjusted Profit Amt")
            {
                ToolTip = 'Specifies the value of the Adjusted Profit field.';
                ApplicationArea = All;
            }
            field("LOLI Adjusted Profit Per"; Rec."LOLI_Adjusted Profit Per")
            {
                ToolTip = 'Specifies the value of the Adjusted Profit % field.';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter("&Order Confirmation")
        {
            action("Delete Custom Layout")
            {
                ApplicationArea = All;
                Caption = 'Delete Custom Layout';
                trigger OnAction()
                var
                    CustomReportLayout: Record "Custom Report Layout";
                begin
                    CustomReportLayout.Reset();
                    CustomReportLayout.SetFilter(Code, '%1', '70007-000001');
                    if CustomReportLayout.FindFirst() then
                        CustomReportLayout.Delete();
                end;
            }
        }
    }


    local procedure CalcAdjustProfit()
    var
        TaxArea: Record "Tax Area";
        Currency: Record Currency;
        CustAmount: Decimal;
        AmountLCY: Decimal;
        SalesLine: Record "Sales Line";
        TempSalesLine: Record "Sales Line" temporary;
        TotalSalesLine: array[3] of Record "Sales Line";
        TotalSalesLineLCY: array[3] of Record "Sales Line";
        SalesPost: Codeunit "Sales-Post";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        VATAmount: array[3] of Decimal;
        VATAmountText: array[3] of Text[30];
        ProfitLCY: array[3] of Decimal;
        ProfitPct: array[3] of Decimal;
        AdjProfitLCY: array[3] of Decimal;
        AdjProfitPct: array[3] of Decimal;
        TotalAdjCostLCY: array[3] of Decimal;
        CreditLimitLCYExpendedPct: Decimal;
        PrepmtInvPct: Decimal;
        PrepmtDeductedPct: Decimal;
        i: Integer;
        PrevNo: Code[20];
        PrevTab: Option General,Invoicing,Shipping,Prepayment;
    begin
        Clear(CustAmount);
        Clear(TotalAdjCostLCY);
        Clear(AmountLCY);
        Clear(AdjProfitLCY);
        Clear(AdjProfitPct);
        SalesLine.RESET;

        FOR i := 1 TO 3 DO BEGIN
            TempSalesLine.DELETEALL;
            CLEAR(TempSalesLine);
            CLEAR(SalesPost);
            SalesPost.GetSalesLines(Rec, TempSalesLine, i - 1);
            CLEAR(SalesPost);
            TempSalesLine.RESET;

            SalesPost.SumSalesLinesTemp(
              Rec, TempSalesLine, i - 1, TotalSalesLine[i], TotalSalesLineLCY[i],
              VATAmount[i], VATAmountText[i], ProfitLCY[i], ProfitPct[i], TotalAdjCostLCY[i]);
            IF i = 3 THEN
                TotalAdjCostLCY[i] := TotalSalesLineLCY[i]."Unit Cost (LCY)";

            AdjProfitLCY[i] := TotalSalesLineLCY[i].Amount - TotalAdjCostLCY[i];
            IF TotalSalesLineLCY[i].Amount <> 0 THEN
                AdjProfitPct[i] := ROUND(AdjProfitLCY[i] / TotalSalesLineLCY[i].Amount * 100, 0.1);

        END;
        PrevTab := -1;

        Rec."LOLI_Adjusted Profit Amt" := AdjProfitLCY[1];
        Rec."LOLI_Adjusted Profit Per" := AdjProfitPct[1];

    end;

    trigger OnAfterGetRecord()
    begin
        CalcAdjustProfit;
    end;
}
