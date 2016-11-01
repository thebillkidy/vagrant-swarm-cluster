import React, { Component } from 'react';
import { connect } from 'react-redux';
import logo from './logo.svg';
import './style.css';
import Swarm from '../../components/Swarm';
import { getSwarmNodes } from '../../reducers/swarmNodes';

const IndexPage = ({ swarmNodes }) => (
    <div className="IndexPage">
        <div className="IndexPage-Header">
            <img src={logo} className="App-logo" alt="logo" />
            <h2>Docker Swarm Visualiser</h2>
        </div>
        <div className="IndexPage-Content">
            <Swarm nodes={swarmNodes} />
        </div>
        <div className="IndexPage-Footer">

        </div>
    </div>
);

const mapStateToProps = state => ({
    swarmNodes: state.swarmNodes
});

export default connect(
    mapStateToProps,
    { } // Actions that can be performed and should be passed here
)(IndexPage);
