import FWCore.ParameterSet.Config as cms
from Configuration.StandardSequences.Eras import eras

process = cms.Process("Demo")
process.load('Configuration.StandardSequences.Services_cff')
process.load('SimGeneral.HepPDTESSource.pythiapdt_cfi')
process.load('Configuration.Geometry.GeometryExtended2023D17Reco_cff')
process.load('Configuration.StandardSequences.MagneticField_cff')
process.load('Configuration.EventContent.EventContent_cff')
process.load("FWCore.MessageService.MessageLogger_cfi")
process.load('Configuration.StandardSequences.FrontierConditions_GlobalTag_cff')
process.load('RecoLocalCalo.HGCalRecProducers.HGCalLocalRecoSequence_cff')
process.load("RecoLocalCalo.HGCalRecProducers.hgcalLayerClusters_cfi")

from Configuration.AlCa.GlobalTag import GlobalTag
process.GlobalTag = GlobalTag(process.GlobalTag, 'auto:phase2_realistic', '')

from FastSimulation.Event.ParticleFilter_cfi import *
from RecoLocalCalo.HGCalRecProducers.HGCalRecHit_cfi import dEdX_weights as dEdX

process.maxEvents = cms.untracked.PSet( input = cms.untracked.int32(DUMMYEVTSPERJOB) )

process.source = cms.Source("PoolSource",
    # replace 'myfile.root' with the source file you want to use
    fileNames = cms.untracked.vstring(
        DUMMYINPUTFILELIST
    ),
    duplicateCheckMode = cms.untracked.string("noDuplicateCheck")
    # inputCommands=cms.untracked.vstring(
    #     'keep *',
    #     'drop EcalEBTriggerPrimitiveDigisSorted_simEcalEBTriggerPrimitiveDigis__HLT'
    # )
)

process.ana = cms.EDAnalyzer('HGCalAnalysis',
                             detector = cms.string("all"),
                             rawRecHits = cms.bool(True),
                             readCaloParticles = cms.bool(False),
                             storeGenParticleOrigin = cms.bool(DUMMYSGO),
                             storeGenParticleExtrapolation = cms.bool(DUMMYSGE),
                             storePCAvariables = cms.bool(False),
                             recomputePCA = cms.bool(False),
                             includeHaloPCA = cms.bool(True),
                             dEdXWeights = dEdX,
                             layerClusterPtThreshold = cms.double(-1),  # All LayerCluster belonging to a multicluster are saved; this Pt threshold applied to the others
                             TestParticleFilter = ParticleFilterBlock.ParticleFilter
)

process.ana.TestParticleFilter.protonEMin = cms.double(100000)
process.ana.TestParticleFilter.etaMax = cms.double(3.1)


process.TFileService = cms.Service("TFileService",
                                   fileName = cms.string("file:DUMMYFILENAME")

                                   )

reRunClustering = DUMMYRECLUST

if reRunClustering:
    # process.hgcalLayerClusters.realSpaceCone = cms.bool(True)
    # process.hgcalLayerClusters.dependSensor = cms.bool(True)
    # process.hgcalLayerClusters.ecut = cms.double(3.)  # multiple of sigma noise if dependSensor is true
    # process.hgcalLayerClusters.kappa = cms.double(9.)  # multiple of sigma noise if dependSensor is true
    process.hgcalLayerClusters.minClusters = cms.uint32(2)
    #process.hgcalLayerClusters.minClusters = cms.uint32(0)
    process.hgcalLayerClusters.multiclusterRadii = cms.vdouble(2.,5.,5.) #(EE,FH,BH), in cm
    #process.hgcalLayerClusters.deltac = cms.vdouble(2.,2.,5.) #(EE,FH,BH), in cm
    process.hgcalLayerClusters.deltac = cms.vdouble(2.,4.,5.) #(EE,FH,BH), in cm
    #process.hgcalLayerClusters.deltac = cms.vdouble(1.5,2.,5.) #(EE,FH,BH), in cm
    #process.hgcalLayerClusters.logWeightZero = cms.double(3.5) #normal weighting if less than 0 (default -1)
    process.p = cms.Path(process.hgcalLayerClusters+process.ana)
else:
    process.p = cms.Path(process.ana)
