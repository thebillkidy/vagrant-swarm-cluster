import React, { Component } from 'react';
import './style.css';

class SwarmNodeContainer extends Component {
    render() {
        const status = this.props.isOnline ? "SwarmNodeContainer-Header-Status-Online" : "SwarmNodeContainer-Header-Status-Offline";

        return (
            <div className="SwarmNodeContainer">
                <div className={status}></div>

                <div className="SwarmNodeContainer-Header">
                    <h1>{this.props.name}</h1>
                </div>
            </div>
        );
    }
}

export default SwarmNodeContainer;
