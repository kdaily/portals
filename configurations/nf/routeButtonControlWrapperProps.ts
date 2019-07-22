import { SynapseConfig } from '../types/portal-config'

const routeButtonControlProps: SynapseConfig = {
  name: 'RouteButtonControlWrapper',
  title: 'Explore',
  props: {
    synapseConfig: {} as SynapseConfig,
    colors: [
      '#119488',
      '#58A058',
      '#407BA0',
      '#5BB0B5',
      'green',
    ],
    customRoutes: [
      'Studies',
      'Datasets',
      'Files',
      'Publications',
      'Tools',
    ]
  }
}

export default routeButtonControlProps
