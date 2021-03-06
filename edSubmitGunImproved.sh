#!/bin/bash

#TIER="GSD"
#TIER="RECO"
#TIER="NTUP"
if [ $# -ne 3 ]
then
  echo "ERROR - needs three arguments"
  echo "First should be one of GSD, RECO, or NTUP"
  echo "Second is the PDGID"
  echo "Third is the pT"
  exit 1
fi
TIER=$1
PARTID=$2
PT=$3

NEVTS=5000
QUEUE="8nh"
#PARTID=22
NPART=1
#PT=35

TAG="escott_PDGid${PARTID}_nPart1_Pt${PT}_AcceptedPR"

EOS="/eos/cms/store/group/dpg_hgcal/comm_hgcal/escott"

RELVAL="/RelValDoublePiPt25Eta17_27/CMSSW_9_0_0_pre5-PU25ns_90X_upgrade2023_realistic_v4_2023D4TnoSmearPU140-v1/GEN-SIM-RECO"

#DATE="20160729" #for "old" sample from Clemens

GSDDATE="20170529"

RECODATE="20170529"

EXTRALABEL=""


if [ "$TIER" == "GSD" ]
then
  EVTSPERJOB=50
  echo "python SubmitHGCalPGun.py --datTier $TIER --nevts $NEVTS --evtsperjob $EVTSPERJOB --queue $QUEUE --partID $PARTID --nPart $NPART --pTmin $PT --pTmax $PT --tag $TAG --eosArea $EOS"
  #python SubmitHGCalPGun.py --datTier $TIER --nevts $NEVTS --evtsperjob $EVTSPERJOB --queue $QUEUE --partID $PARTID --nPart $NPART --thresholdMin $PT --thresholdMax $PT --tag $TAG --eosArea $EOS --dry-run
  python SubmitHGCalPGun.py --datTier $TIER --nevts $NEVTS --evtsperjob $EVTSPERJOB --queue $QUEUE --partID $PARTID --nPart $NPART --thresholdMin $PT --thresholdMax $PT --tag $TAG --eosArea $EOS
fi


if [ "$TIER" == "RECO" ]
then
  EVTSPERJOB=200
  echo "python SubmitHGCalPGun.py --datTier $TIER --evtsperjob $EVTSPERJOB --queue $QUEUE --tag $TAG$EXTRALABEL --eosArea $EOS --inDir partGun_${TAG}_$GSDDATE"
  python SubmitHGCalPGun.py --datTier $TIER --evtsperjob $EVTSPERJOB --queue $QUEUE --tag $TAG$EXTRALABEL --eosArea $EOS --inDir partGun_${TAG}_$GSDDATE
fi


if [ "$TIER" == "NTUP" ]
then
  EVTSPERJOB=200
  echo "python SubmitHGCalPGun.py --datTier $TIER --evtsperjob $EVTSPERJOB --queue $QUEUE --tag $TAG${EXTRALABEL} --eosArea $EOS --inDir partGun_${TAG}${EXTRALABEL}_$RECODATE"
  python SubmitHGCalPGun.py --datTier $TIER --evtsperjob $EVTSPERJOB --queue $QUEUE --tag ${TAG}${EXTRALABEL} --eosArea $EOS --inDir partGun_${TAG}${EXTRALABEL}_$RECODATE
  #python SubmitHGCalPGun.py --datTier $TIER --evtsperjob $EVTSPERJOB --queue $QUEUE --eosArea $EOS -r $RELVAL #--dry-run
fi
