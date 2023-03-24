DECLARE @CurrentMonth INT, @CurrentYear INT;
SET @CurrentMonth = 2;
SET @CurrentYear = 2023;

SELECT
  Clinics.ClinicNameShort as department,
  ppd.idpt,
  ppd.NameFull as fullName,
  FORMAT(CAST(dpp.dtStartProc as datetime2), N'dd-MM-yyyy') as procedureDate,
  DurationMINproc as procedureDuration, 
  QbProc as procedureQb,
  DryWeightHDPrescription as dryWeight,
  ktv.KtVdaugerdas as ktv,
  usedDialiser = CASE dpl.idProductType
      WHEN 2725 THEN '22HF'
      WHEN 2764 THEN '20HF'
      WHEN 2762 THEN '15HF'
      WHEN 2763 THEN '18HF'
      WHEN 2471 THEN '18HF'
      WHEN 2404 THEN '20HF'
      WHEN 2722 THEN '15HF'
      WHEN 2723 THEN '18HF'
      WHEN 2724 THEN '20HF'
      WHEN 2725 THEN '22HF'
      WHEN 2670 THEN '20HF'
      WHEN 2676 THEN '22HF'
      WHEN 2747 THEN '20HF'
      WHEN 2708 THEN '15HF'
      WHEN 2709 THEN '18HF'
      WHEN 2711 THEN '20HF'
      WHEN 2713 THEN '22HF'
      ELSE CAST(dpl.idProductType as VARCHAR)
      END,
  recommendedDialyser = CASE
      WHEN DurationMINproc >= 240 and QbProc >=358 THEN '22HF'
      WHEN DurationMINproc >= 220 and QbProc >= 287 THEN 'V-20HF/Revaclear 400'
      WHEN DurationMINproc >= 210 and QbProc >= 266 THEN 'V-18H'
      ELSE 'HF15'
      END
  --ptypes.strNameShort as 'Диализатор'
FROM DialysisProcParam dpp
JOIN PatientPersonData ppd on ppd.idpt = dpp.idpt and ppd.idClinic=dpp.idClinic
JOIN Clinics on dpp.idClinic = Clinics.idClinic
JOIN ActualPatientList apl on dpp.keyPtCD = apl.keyPtCD
JOIN tbProductTypes_LinkType ptl on ptl.id = dpp.DialyzerProc
JOIN DialyzerProcLink dpl on dpl.idClinic = dpp.idClinic and dpl.iProcID = dpp.iProcID and dpl.idGlobalProductType = 1
LEFT JOIN KtVdaugerdas ktv on dpp.idpt = ktv.idpt and dpl.idClinic = ktv.idClinic and YEAR(ktv.dt) = @CurrentYear and MONTH(ktv.dt) = @CurrentMonth
--JOIN [ms002-replics01.nes.lan].[maximus_cloud].[dbo].[tbProductTypes] ptypes on dpl.idGlobalProductType = ptypes.iProductTypeID
WHERE 
    YEAR(dpp.dtStartProc) = @CurrentYear
    and MONTH (dpp.dtStartProc) = @CurrentMonth
    and apl.idHosptypeA = 1
    and dpp.DurationMINproc < 480
    and dpp.DurationMINproc > 180
    and dpp.QbProc >= 100
    and apl.Renal = 1
ORDER BY Clinics.ClinicNameShort, ppd.NameFull
