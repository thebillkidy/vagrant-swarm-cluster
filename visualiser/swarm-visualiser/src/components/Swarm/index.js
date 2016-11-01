import React, { PropTypes } from 'react';
import './style.css';
import SwarmNode from '../SwarmNode';

const Swarm = ({ nodes }) => (
    <div className="Swarm">
        {nodes.map(sn => <SwarmNode name={sn.name} type={sn.type} ram={sn.ram} containers={sn.containers} /> )}
    </div>
);

Swarm.propTypes = {
    nodes: PropTypes.arrayOf(PropTypes.shape({
        name: PropTypes.string.isRequired,
        type: PropTypes.string.isRequired,
        ram: PropTypes.string.isRequired,
        containers: PropTypes.arrayOf(PropTypes.shape({
            name: PropTypes.string.isRequired,
            isOnline: PropTypes.bool.isRequired
        }))
    })).isRequired
};

export default Swarm;
