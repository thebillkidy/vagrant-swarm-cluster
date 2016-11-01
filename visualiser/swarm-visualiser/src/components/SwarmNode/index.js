import React, { Component } from 'react';
import './style.css';
import SwarmNodeContainer from '../SwarmNodeContainer';

class SwarmNode extends Component {
    render() {
        return (
            <div className="SwarmNode">
                <div className="SwarmNode-Header">
                    <h1>{this.props.name}</h1>
                    <h2>{this.props.type}</h2>
                    <p>{this.props.ram}Gb RAM</p>
                </div>

                <div className="SwarmNode-Containers">
                    {this.props.containers.map(c => <SwarmNodeContainer name={c.name} color="black" isOnline={c.isOnline} /> )}
                </div>
            </div>
        );
    }
}

export default SwarmNode;
