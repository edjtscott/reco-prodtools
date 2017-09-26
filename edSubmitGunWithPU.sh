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

#NEVTS=1000
NEVTS=2000
QUEUE="8nh"
#PARTID=22
NPART=1
#PT=35

NPU="200"

TAG="escott_PDGid${PARTID}_nPart1_Pt${PT}_93X_PU$NPU"

EOS="/eos/cms/store/group/dpg_hgcal/comm_hgcal/escott"

RELVAL="/RelValDoublePiPt25Eta17_27/CMSSW_9_0_0_pre5-PU25ns_90X_upgrade2023_realistic_v4_2023D4TnoSmearPU140-v1/GEN-SIM-RECO"
#RELVAL="/RelValZTT_14TeV/CMSSW_9_1_1-PU25ns_91X_upgrade2023_realistic_v1_D17PU200-v1/GEN-SIM-RECO"

#DATE="20160729" #for "old" sample from Clemens

GSDDATE="20170920"

RECODATE="20170920"

EXTRALABEL=""
#EXTRALABEL="_50mm"
#EXTRALABEL="_EE2FH5BH5"
#EXTRALABEL="_255_225"
#EXTRALABEL="_1dot5"
#EXTRALABEL=""

#PUDS="/MinBias_TuneCUETP8M1_14TeV-pythia8/PhaseIIFall16GS82-90X_upgrade2023_realistic_v1-v1/GEN-SIM"
#PUDS="/MinBias_TuneCUETP8M1_14TeV-pythia8/PhaseIISpring17GS-90X_upgrade2023_realistic_v9-v1/GEN-SIM"
PUDS="/MinBias_TuneCUETP8M1_14TeV-pythia8/PhaseIITDRSpring17GS-91X_upgrade2023_realistic_v2-v1/GEN-SIM"


if [ "$TIER" == "GSD" ]
then
  #EVTSPERJOB=10
  EVTSPERJOB=20
  echo "python SubmitHGCalPGun.py --datTier $TIER --nevts $NEVTS --evtsperjob $EVTSPERJOB --queue $QUEUE --partID $PARTID --nPart $NPART --thresholdMin $PT --thresholdMax $PT --tag $TAG --eosArea $EOS --PU $NPU --PUDS $PUDS --etaMin 1.7 --etaMax 2.7"
  #python SubmitHGCalPGun.py --datTier $TIER --nevts $NEVTS --evtsperjob $EVTSPERJOB --queue $QUEUE --partID $PARTID --nPart $NPART --thresholdMin $PT --thresholdMax $PT --tag $TAG --eosArea $EOS --PU $NPU --PUDS $PUDS --dry-run
  python SubmitHGCalPGun.py --datTier $TIER --nevts $NEVTS --evtsperjob $EVTSPERJOB --queue $QUEUE --partID $PARTID --nPart $NPART --thresholdMin $PT --thresholdMax $PT --tag $TAG --eosArea $EOS --PU $NPU --PUDS $PUDS --etaMin 1.7 --etaMax 2.7
fi


if [ "$TIER" == "RECO" ]
then
  #EVTSPERJOB=40
  EVTSPERJOB=80
  echo "python SubmitHGCalPGun.py --datTier $TIER --evtsperjob $EVTSPERJOB --queue $QUEUE --tag $TAG$EXTRALABEL --eosArea $EOS --inDir FlatRandomPtGunProducer_${TAG}_$GSDDATE"
  python SubmitHGCalPGun.py --datTier $TIER --evtsperjob $EVTSPERJOB --queue $QUEUE --tag $TAG$EXTRALABEL --eosArea $EOS --inDir FlatRandomPtGunProducer_${TAG}_$GSDDATE
fi


if [ "$TIER" == "NTUP" ]
then
  #EVTSPERJOB=40
  EVTSPERJOB=80
  echo "python SubmitHGCalPGun.py --datTier $TIER --evtsperjob $EVTSPERJOB --queue $QUEUE --tag $TAG${EXTRALABEL} --eosArea $EOS --inDir FlatRandomPtGunProducer_${TAG}_$RECODATE"
  python SubmitHGCalPGun.py --datTier $TIER --evtsperjob $EVTSPERJOB --queue $QUEUE --tag ${TAG}${EXTRALABEL} --eosArea $EOS --inDir FlatRandomPtGunProducer_${TAG}_$RECODATE --noReClust
  #python SubmitHGCalPGun.py --datTier $TIER --evtsperjob $EVTSPERJOB --queue $QUEUE --eosArea $EOS -r $RELVAL #--dry-run
fi
