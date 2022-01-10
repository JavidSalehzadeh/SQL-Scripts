

exec fin_AccountLevels_DuplicateFiscalYear @SourceFiscalYearDetailGuid='CAA314E2-52C3-4330-920A-43F82D1F2A93',
@TargetFiscalYearDetailGuid='BDAEEEA3-AFCC-4334-BA1B-87F1D61D318C',@TargetFiscalYear=1399

exec fin_FloatAccountsCategory_DuplicateFiscalYear @SourceFiscalYearDetailGuid='CAA314E2-52C3-4330-920A-43F82D1F2A93',
@TargetFiscalYearDetailGuid='BDAEEEA3-AFCC-4334-BA1B-87F1D61D318C',@TargetFiscalYear=1399,
@DuplicationBatchGuid='3EF661F8-FE84-4A8C-AE71-3EAA4CBA8D3D'

exec fin_Accounts_BatchCopy @SourceAccountMappingGuid='00000000-0000-0000-0000-000000000000',
@SourceFiscalYearDetailGuid='CAA314E2-52C3-4330-920A-43F82D1F2A93',@TargetFiscalYearDetailGuid='BDAEEEA3-AFCC-4334-BA1B-87F1D61D318C',
@TargetFiscalYear=1399,@IncludeInactive=1,@DuplicationBatchGuid='3EF661F8-FE84-4A8C-AE71-3EAA4CBA8D3D'

exec fin_FixedAccountMappers_DuplicateFiscalYear @SourceFiscalYearDetailGuid='CAA314E2-52C3-4330-920A-43F82D1F2A93',
@TargetFiscalYearDetailGuid='BDAEEEA3-AFCC-4334-BA1B-87F1D61D318C',@TargetFiscalYear=1399,
@DuplicationBatchGuid='3EF661F8-FE84-4A8C-AE71-3EAA4CBA8D3D'

exec fin_AccountMappings_BatchCopy @SourceAccountMappingGuid='00000000-0000-0000-0000-000000000000',
@TargetAccountMappingGuid='00000000-0000-0000-0000-000000000000',@SourceFiscalYearDetailGuid='CAA314E2-52C3-4330-920A-43F82D1F2A93',
@TargetFiscalYearDetailGuid='BDAEEEA3-AFCC-4334-BA1B-87F1D61D318C',@TargetFiscalYear=1399,@IncludeInactive=1,
@DuplicationBatchGuid='3EF661F8-FE84-4A8C-AE71-3EAA4CBA8D3D'

exec fin_AccountMappings_FinalizeBatchCopy @SourceAccountMappingGuid='00000000-0000-0000-0000-000000000000',
@TargetAccountMappingGuid='00000000-0000-0000-0000-000000000000',@SourceFiscalYearDetailGuid='CAA314E2-52C3-4330-920A-43F82D1F2A93',
@TargetFiscalYearDetailGuid='BDAEEEA3-AFCC-4334-BA1B-87F1D61D318C',@IncludeInactive=1,
@DuplicationBatchGuid='3EF661F8-FE84-4A8C-AE71-3EAA4CBA8D3D'

exec fin_AccountExternalEntity_DuplicateFiscalYear @SourceFiscalYearDetailGuid='CAA314E2-52C3-4330-920A-43F82D1F2A93',
@TargetFiscalYearDetailGuid='BDAEEEA3-AFCC-4334-BA1B-87F1D61D318C'

exec fin_PredefinedDescriptions_DuplicateFiscalYear @SourceFiscalYearDetailGuid='CAA314E2-52C3-4330-920A-43F82D1F2A93',
@TargetFiscalYearDetailGuid='BDAEEEA3-AFCC-4334-BA1B-87F1D61D318C'

exec fin_Sanama_DuplicateFiscalYear @SourceFiscalYearDetailGuid='CAA314E2-52C3-4330-920A-43F82D1F2A93',
@TargetFiscalYearDetailGuid='BDAEEEA3-AFCC-4334-BA1B-87F1D61D318C'

exec fin_Sana_DuplicateFiscalYear @SourceFiscalYearDetailGuid='CAA314E2-52C3-4330-920A-43F82D1F2A93',
@TargetFiscalYearDetailGuid='BDAEEEA3-AFCC-4334-BA1B-87F1D61D318C'
