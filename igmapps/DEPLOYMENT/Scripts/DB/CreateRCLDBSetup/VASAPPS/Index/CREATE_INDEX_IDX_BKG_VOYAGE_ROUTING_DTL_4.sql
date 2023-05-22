CREATE INDEX "SEALINER"."IDX_BKG_VOYAGE_ROUTING_DTL_4" ON "SEALINER"."BOOKING_VOYAGE_ROUTING_DTL"
    (
      "VESSEL",
      "LOAD_PORT",
      "DISCHARGE_PORT",
      "POL_PCSQ",
      "POD_PCSQ"
    )
TABLESPACE INDX
;