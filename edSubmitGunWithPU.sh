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

NEVTS=1000
QUEUE="8nh"
#PARTID=22
NPART=1
#PT=35

#TAG="escott_PDGid${PARTID}_nPart1_Pt${PT}_AcceptedPR_PU200"
TAG="escott_PDGid${PARTID}_nPart1_Pt${PT}_D17_PU200"

EOS="/eos/cms/store/group/dpg_hgcal/comm_hgcal/escott"

RELVAL="/RelValDoublePiPt25Eta17_27/CMSSW_9_0_0_pre5-PU25ns_90X_upgrade2023_realistic_v4_2023D4TnoSmearPU140-v1/GEN-SIM-RECO"

#DATE="20160729" #for "old" sample from Clemens

#GSDDATE="20170530" #using PR as accepted
GSDDATE="20170615" #using PR as accepted, but with D17 now

#RECODATE="20170530"
#RECODATE="20170531"
RECODATE="20170615"

EXTRALABEL=""
#EXTRALABEL="_50mm"
#EXTRALABEL="_EE2FH5BH5"
#EXTRALABEL="_255_225"

NPU="200"

PUDS="/MinBias_TuneCUETP8M1_14TeV-pythia8/PhaseIISpring17GS-90X_upgrade2023_realistic_v9-v1/GEN-SIM"


if [ "$TIER" == "GSD" ]
then
  EVTSPERJOB=10
  echo "python SubmitHGCalPGun.py --datTier $TIER --nevts $NEVTS --evtsperjob $EVTSPERJOB --queue $QUEUE --partID $PARTID --nPart $NPART --pTmin $PT --pTmax $PT --tag $TAG --eosArea $EOS --PU $NPU --PUDS $PUDS"
  #python SubmitHGCalPGun.py --datTier $TIER --nevts $NEVTS --evtsperjob $EVTSPERJOB --queue $QUEUE --partID $PARTID --nPart $NPART --thresholdMin $PT --thresholdMax $PT --tag $TAG --eosArea $EOS --PU $NPU --PUDS $PUDS --dry-run
  python SubmitHGCalPGun.py --datTier $TIER --nevts $NEVTS --evtsperjob $EVTSPERJOB --queue $QUEUE --partID $PARTID --nPart $NPART --thresholdMin $PT --thresholdMax $PT --tag $TAG --eosArea $EOS --PU $NPU --PUDS $PUDS
fi


if [ "$TIER" == "RECO" ]
then
  EVTSPERJOB=40
  echo "python SubmitHGCalPGun.py --datTier $TIER --evtsperjob $EVTSPERJOB --queue $QUEUE --tag $TAG$EXTRALABEL --eosArea $EOS --inDir FlatRandomPtGunProducer_${TAG}_$GSDDATE"
  python SubmitHGCalPGun.py --datTier $TIER --evtsperjob $EVTSPERJOB --queue $QUEUE --tag $TAG$EXTRALABEL --eosArea $EOS --inDir FlatRandomPtGunProducer_${TAG}_$GSDDATE
fi


if [ "$TIER" == "NTUP" ]
then
  EVTSPERJOB=40
  echo "python SubmitHGCalPGun.py --datTier $TIER --evtsperjob $EVTSPERJOB --queue $QUEUE --tag $TAG${EXTRALABEL} --eosArea $EOS --inDir FlatRandomPtGunProducer_${TAG}${EXTRALABEL}_$RECODATE"
  python SubmitHGCalPGun.py --datTier $TIER --evtsperjob $EVTSPERJOB --queue $QUEUE --tag ${TAG}${EXTRALABEL} --eosArea $EOS --inDir FlatRandomPtGunProducer_${TAG}${EXTRALABEL}_$RECODATE
  #python SubmitHGCalPGun.py --datTier $TIER --evtsperjob $EVTSPERJOB --queue $QUEUE --eosArea $EOS -r $RELVAL #--dry-run
fi
