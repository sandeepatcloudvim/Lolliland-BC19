pageextension 54517 "SalesOrderStatistics_Ext" extends "Sales Order Statistics"
{
    layout
    {
        addafter(NoOfVATLines_General)
        {
            field("LOLI_Pallet Total"; REC."LOLI_Pallet Total")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetRecord()
    begin
        CalcAdjustProfit();
    end;

    local procedure CalcAdjustProfit()
    var
        TaxArea: Record "Tax Area";
        Currency: Record Currency;
        CustAmount: Decimal;
        AmountLCY: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";
        SalesLine: Record "Sales Line";
        TempSalesLine: Record "Sales Line" temporary;
        //TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        TotalSalesLine: array[3] of Record "Sales Line";
        TotalSalesLineLCY: array[3] of Record "Sales Line";
        Cust: Record Customer;
        SalesSetup: Record "Sales & Receivables Setup";
        //SalesTaxDifference: Record "Sales Tax Amount Difference";
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
        SalesRecv: Record "Sales & Receivables Setup";
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
            SalesRecv.Get();

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

        Rec."LOLI_Volume" := TotalSalesLine[1]."Unit Volume";
        Rec."LOLI_Gross Weight" := TotalSalesLine[1]."Gross Weight";

        if TotalSalesLine[1]."Unit Volume" > 0 then begin
            if SalesRecv."LOLI_Pallet Volume Formula" <> 0 then
                Rec."LOLI_No. of Pallet Height" := (TotalSalesLine[1]."Unit Volume" / SalesRecv."LOLI_Pallet Volume Formula")
            else
                Rec."LOLI_No. of Pallet Height" := (TotalSalesLine[1]."Unit Volume" / 2.9)
        end;

        if TotalSalesLine[1]."Gross Weight" > 0 then begin
            if SalesRecv."LOLI_Pallet Weight Formula" <> 0 then
                Rec."LOLI_No. of Pallet Weight" := (TotalSalesLine[1]."Gross Weight" / SalesRecv."LOLI_Pallet Weight Formula")
            else
                Rec."LOLI_No. of Pallet Weight" := (TotalSalesLine[1]."Gross Weight" / 1020)
        end;

        if (Rec."LOLI_No. of Pallet Height" <= Rec."LOLI_No. of Pallet Weight") then
            Rec."LOLI_Pallet Total" := Rec."LOLI_No. of Pallet Weight"
        else
            Rec."LOLI_Pallet Total" := Rec."LOLI_No. of Pallet Height";

        Rec."LOLI_Adjusted Profit Amt" := AdjProfitLCY[1];
        Rec."LOLI_Adjusted Profit Per" := AdjProfitPct[1];

    end;

    var
        myInt: Integer;
}