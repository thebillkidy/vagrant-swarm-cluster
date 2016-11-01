import docker from '../api/docker';
import * as types from '../constants/ActionTypes';

const receiveSwarmNodes = nodes => ({
    type: types.RECEIVE_SWARM_NODES,
    nodes: nodes
});

export const getAllSwarmNodes = () => dispatch => {
    docker.getSwarmNodes(nodes => {
        dispatch(receiveSwarmNodes(nodes));
    });
};