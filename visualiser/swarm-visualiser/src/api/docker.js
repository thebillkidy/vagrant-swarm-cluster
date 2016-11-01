// Mock nodes
import _nodes from './nodes.json';

const TIMEOUT = 100;

export default {
    getSwarmNodes: (cb, timeout) => setTimeout(() => cb(_nodes), timeout || TIMEOUT)
}