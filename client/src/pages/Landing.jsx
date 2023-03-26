/* eslint-disable */
import React, { useContext, useState, useEffect } from 'react';
import { NavLink } from 'react-router-dom';
import Web3Context from '../contexts';

import Navbar from '../components/Navbar';

//import backgroundImage from './photo.png';

//import gif from './ezgif.com-resize.gif';

import gifnetwork from './network.gif';


function Landing() {
  const { account, sellerI } = useContext(Web3Context);

  return (
    <>

      <div>
        <Navbar />
        <div className="w-full h-screen bg-new-secondary flex justify-center items-center"
          style={{
            backgroundImage: `url(${gifnetwork})`, backgroundSize: 'cover'
          }}

        >


          <div className="left w-1/2 ml-32">
            <div className="flex flex-col justify-start items-start text-center">
              <div className="title font-bold text-5xl text-black justify-center" style={{ color: 'white' }}>
                On-Chain Warranties for Products
              </div>
              <div className="info mt-5 text-1xl text-center" style={{ color: 'white' }}>
                Free up your cupboard spaces and store your warranties in the
                digital world in the form of NFTs having proper ownership proof
                over it. Now the warranty is not a piece of paper but a form of
                token. Start issuing warranties for your products by registering
                below.
              </div>
              <div className="buttons w-full mt-8 flex justify-center items-center">
                {sellerI == 0 ? (
                  <NavLink
                    to="/createseller"
                    className="bg-new w-60 text-white p-4 text-center rounded-2xl"
                  >
                    Register as Seller
                  </NavLink>
                ) : (
                  <NavLink
                    className="bg-new w-60 text-white p-4 text-center rounded-2xl"
                    to={`seller/${account.currentAccount}`}
                  //style={{backgroundColor:'white'}}
                  >
                    Seller
                  </NavLink>
                )}
                <NavLink
                  to={`/buyer/${account.currentAccount}`}
                  className="bg-new w-60 text-white p-4 ml-2 text-center rounded-2xl"
                >
                  Customer
                </NavLink>
              </div>
            </div>
          </div>

        </div>
      </div>
    </>
  );
}

export default Landing;
