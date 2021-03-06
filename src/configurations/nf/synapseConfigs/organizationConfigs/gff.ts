import { SynapseConstants } from 'synapse-react-client'
import { BaseRoute } from 'types/portal-config'
import { buttonColors } from '../commonProps'
import { generateOrgConfig } from './generateConfig'
import { studiesEntityId } from '../studies'
import { datasetsEntityId } from '../datasets'
import { filesEntityId } from '../files'
import { publicationsEntityId } from '../publications'

const org = 'GFF'

export const gff: BaseRoute = {
  name: 'GFF',
  to: '/Organizations/GFF',
  isNested: false,
  synapseConfigArray: [
    {
      name: 'CardContainerLogic',
      props: {
        limit: 1,
        sql: "SELECT * FROM syn16858699 WHERE abbreviation = 'GFF'",
        type: SynapseConstants.FUNDER,
        entityId: 'syn16858699',
      },
      title: 'Gilbert Family Foundation (GFF)',
    },
    {
      name: 'StatefulButtonControlWrapper',
      props: {
        ...buttonColors,
        configs: [
          {
            name: 'Studies',
            sql: generateOrgConfig(org, 'Studies', true),
            entityId: studiesEntityId,
            synapseConfigArray: generateOrgConfig(org, 'Studies', false),
          },
          {
            name: 'Datasets',
            sql: generateOrgConfig(org, 'Dataset', true),
            entityId: datasetsEntityId,
            synapseConfigArray: generateOrgConfig(org, 'Dataset', false),
          },
          {
            name: 'Files',
            sql: generateOrgConfig(org, 'Files', true),
            entityId: filesEntityId,
            synapseConfigArray: generateOrgConfig(org, 'Files', false),
          },
          {
            name: 'Publications',
            sql: generateOrgConfig(org, 'Publications', true),
            entityId: publicationsEntityId,
            synapseConfigArray: generateOrgConfig(org, 'Publications', false),
          },
        ],
      },
    },
  ],
}
