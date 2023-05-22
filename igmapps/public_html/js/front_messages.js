/******************************************************************************/
/*                                                                            */
/*                         Front End Error Messages                           */
/*                                                                            */
/******************************************************************************/

/*General Error Messages*/
ECM_GE0001='Database Error Occurred';
ECM_GE0002='Record Locked By Another User';
ECM_GE0003='Division By Zero Error';
ECM_GE0004='No Record Found';
ECM_GE0005='Record deleted By Another User';
ECM_GE0006='Record updated By Another User';
ECM_GE0007='Please select a row';
ECM_GE0008='Invalid Date Format';
ECM_GE0009='Please select a .xls file';
ECM_GE0010='Mandatory value not selected';
ECM_GE0011='Mandatory value not entered';
ECM_GE0012='Please enter a valid number';
ECM_GE0013='Please Save changes first';
ECM_GE0014='No changes to Save';
ECM_GE0015='Invalid Master Code';
ECM_GE0016='Executable file cannot be uploaded';
ECM_GE0017='Error While File Upload';
ECM_GE0018='File name more than 50 characters';
ECM_GE0019='Uploaded Directory does not exist';
ECM_GE0020='File Size should not be greater than {0} MB'; 
ECM_GE0021='Invalid Template File';
ECM_GE0022='File does not exist on Server';
ECM_GE0023='Please select a File';

/*General Informations Messages*/
ECM_GI0001='Ready';
ECM_GI0002='{0} Row(s) Retrieved';
ECM_GI0003='Save Successful';
ECM_GI0004='Match Processed';

/*General Warning Messages*/
ECM_GW0001='Do you wish to delete the selected record(s)?';
ECM_GW0002='Do you wish to cancel?';
ECM_GW0003='Do you wish to send via email?';
ECM_GW0004='Do you wish to save changes?';

/*Specific error messages - Discharge list overview*/
ELL_SE0001='Port not entered';
ELL_SE0002='Terminal not entered';
ELL_SE0003='FSC not entered';
ELL_SE0004='Out Voyage not entered';
ELL_SE0005='From Ata Date cannot be blank';
ELL_SE0006='To Ata Date cannot be blank';
ELL_SE0007='Status cannot be blank';
ELL_SE0008='From Eta Date cannot be blank';
ELL_SE0009='To Eta Date cannot be blank';
ELL_SE0010='From Eta Date is invalid';
ELL_SE0011='To Eta Date is invalid';
ELL_SE0012='From Ata Date is invalid';
ELL_SE0013='To Ata Date is invalid';
ELL_SE0014='From Eta Date cannot be greater than To Eta Date';
ELL_SE0015='From Ata Date cannot be greater than To Ata Date';
ELL_SE0016='Status not selected';
ELL_SE0017='Either Eta or Ata date pair must be entered';

/*Specific Error Messages - Discharge list Maintainence.*/
EZL_SE001='Container operator should not be null at line no {0}';
EZL_SE002='Discharge Status should not be null at line no {0}';
EZL_SE003='Load Condition should not be null at line no {0}';
EZL_SE004='Equipment# is mandatory for new record.';
EZL_SE005='Container Operator should be RCL.';
EZL_SE006='Stow Position can not be null for discharge status Discharged or ROB.';
EZL_SE007='Stow Position length should be seven at line no {0}';
EZL_SE008='Size mismatch for current stow position.';
EZL_SE009='Invalid MLO Eta Date at line no {0}';
EZL_SE010='Equipment # not entered.';
EZL_SE011='Stowage Position is mandatory at line no {0}';
EZL_SE012='Size does not match bay number at line no {0}';
EZL_SE013='Invalid Activity Date at line no {0}';
EZL_SE014='Odd tier numbers are reserved for half height containers at line no {0}';
EZL_SE015='Select at least one value in IN1 search criteria';
EZL_SE016='Please enter a value in Find1 field';
EZL_SE017='Select at least one value in IN2 search criteria';
EZL_SE018='Please enter a value in Find2 field';
EZL_SE019='Invalid weight value at line no {0}';
EZL_SE020='Invalid flash point value at line no {0}';
EZL_SE021='Invalid overheight value at line no {0}';
EZL_SE022='Invalid overwidthLeft value at line no {0}';
EZL_SE023='Invalid overwidthRight value at line no {0}';
EZL_SE024='Invalid overlengthFront value at line no {0}';
EZL_SE025='Invalid overlengthAfter value at line no {0}';
EZL_SE026='Load Condition can not be null at line no {0}';
EZL_SE027='Shipment Term can not be null at line no {0}';
EZL_SE028='Shipment Type can not be null at line no {0}';
EZL_SE029='Equipment # can not be null at line no {0}';
EZL_SE030='Container Operator can not be null at line no {0}';
EZL_SE031='Size can not be null at line no {0}';
EZL_SE032='Booking Type can not be null at line no {0}';
EZL_SE033='Slot Operator can not be null at line no {0}';
EZL_SE034='Special Cargo can not be null at line no {0}';
EZL_SE035='Soc Coc can not be null at line no {0}';
EZL_SE036='Invalid size value at line no {0}';
EZL_SE037='Invalid humidity value at line no {0}';


EZL_SE038='Invalid Handling Instruction Code1 value';
EZL_SE039='Invalid Operator Code';
EZL_SE040='Invalid Handling Instruction Code2 value';
EZL_SE041='Invalid Handling Instruction Code3 value';
EZL_SE042='Invalid Shipment Term Code value';
EZL_SE043='Invalid Stowage Position value at line no {0}';
EZL_SE044='Invalid Out Slot Operator Code value';
EZL_SE045='Invalid Slot Operator Code value';
EZL_SE046='Invalid Reefer Temperature value at line no {0}';
EZL_SE047='Stowage position length should be seven';
EZL_SE048='Invalid Equipment Type';
EZL_SE049='Invalid Port code';
EZL_SE050='Invalid Port Terminal code';
EZL_SE051='Equipment # is mandatory at line no {0}';
EZL_SE052='Stowage Position # is mandatory at line no {0}';
EZL_SE053='Please enter container sequence no.';
EZL_SE054='Split can not be performed';
EZL_SE055='Booking No. can not be null at line no {0}';
EZL_SE056='Invalid ventilation value at line no {0}';
EZL_SE057='Please select Restow Status at line no {0}';
EZL_SE058='Loading Status should not be null at line no {0}';

/* Specific error messages for Save Settings*/
ECM_SE0001='Please enter View name';
ECM_SE0002='Please select View type';


/*Added By Ankit*/
ECM_SE0003='Template Description cannot be blank';
ECM_SE0004='Template Language must be unique'; 
ECM_SE0005='Subject cannot be blank';
ECM_SE0006='Either Body Header or Body Detail or Body Footer must be provided';
ECM_SE0007='Search Not Performed';
ECM_SE0008='Select IN criteria at least one value';
ECM_SE0009='Please enter a value in Find field';
ECM_SE0010='You are not authorized to create/save FSC Level view';
ECM_SE0011='You are not authorized to create/save Global view';

/*Added for E-Notice*/
ECM_SE0012='Notice type must be selected';
ECM_SE0013='Subject cannot be greater than 1000 characters';
ECM_SE0014='Body header cannot be greater than 4000 characters';
ECM_SE0015='Body detail cannot be greater than 4000 characters';
ECM_SE0016='Body footer cannot be greater than 4000 characters';
ECM_SE0017='Please select a Notice Type';
ECM_SE0018='Please select an Organization Type';
ECM_SE0019='Recipient Organization cannot be blank';
ECM_SE0020='Changes must be saved first before viewing/adding recipients';
ECM_SE0021='Recipient Type cannot be blank';
ECM_SE0022='Email Id cannot be blank';
ECM_SE0023='Booking number cannot be Blank';
ECM_SE0024='B/L number cannot be blank';
ECM_SE0025='Kind of return cannot be blank';
ECM_SE0026='Please enter valid Email Id';
ECM_SE0027='Port of loading not entered';
ECM_SE0028='Message Receipient Can not be blank'; 
ECM_SE0029='Message Set Can not be blank';

// Add by THIWAT1 15/09/16
ECM_SE0030='Invalid port as place of delivery';

EZL_SE0100='Enter atleast one field value';
EZL_SE0101='Booking number cannot be Blank';
EZL_SE0102='B/L number cannot be blank';
EZL_SE0103='Kind of return cannot be blank';
EZL_SE0104='Date Cannot be Blank';
EZL_SE0105='Please enter new container number';
EZL_SE0106='Please enter new shippers seal';
EZL_SE0107='Reason Cannot be Blank';
EZL_SE0108='Enter at least one search criteria field.';
EZL_SE0109='Invalid Conatiner Operator';
EZL_SE0110='Time Cannot be Blank';
EZL_SE0111='Enter valid time.';
EZL_SE0112='Time should be of 4 characters';
EZL_SE0113='Please select one category at line no {0} ';


EDL_SE0001='Booking number cannot be Blank';
EDL_SE0003='B/L number cannot be blank';
EDL_SE0005='Kind of return cannot be blank';
