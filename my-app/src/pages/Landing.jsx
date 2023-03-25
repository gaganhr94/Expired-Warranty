/* eslint-disable */
import React, { useContext, useState, useEffect } from 'react';
import { NavLink } from 'react-router-dom';
import Web3Context from '../contexts';
import backgroundImage from './black.png';
import Navbar from '../components/Navbar';
//import { motion } from "framer-motion";
function Landing() {
  const { account, sellerI } = useContext(Web3Context);

  return (
    <>
      <div>
        <Navbar />
        <div className="w-full h-screen  flex justify-center items-center" style={{
          backgroundImage: `url(${backgroundImage})`, backgroundSize:'cover'}}>
          <div className="left w-1/2 ml-32 ">
            <div className="flex flex-col justify-start items-start" style={{
              //backgroundColor: 'black',
              color: 'white',
              borderRadius: '30px',
              height: '110%',
              width: '120%',
              marginLeft:'-50px'
            }}>
              <div className="title font-bold text-4xl text-black " style={{
                color: 'white',
                marginLeft: '80px',
                marginTop:'30px'
              }}>
                On-Chain Warranties for Products
              </div>
              <div className="info mt-5" style={{ marginLeft: '20px' }}>
                Free up your cupboard spaces and store your warranties in the
                digital world in the form of NFTs having proper ownership proof
                over it. Now the warranty is not a piece of paper but a form of
                token. Start issuing warranties for your products by registering
                below.
              </div>
               <div className="buttons w-full mt-8 flex justify-start items-center"
                
              > 
                {sellerI == 0 ? (
                  <NavLink
                    to="/createseller"
                    className="bg-new w-36 text-white p-2 text-center rounded-2xl"
                    style={{
                      marginLeft: "190px",
                      marginBottom: '30px',
                      backgroundColor: '#0f3d3e',
                      color: 'white'
                    }}
                  >
                    Register as Seller
                  </NavLink>
                ) : (
                  <NavLink
                    to={`seller/${account.currentAccount}`}
                      className="bg-new w-32 text-white p-2 text-center rounded-2xl"
                      style={{
                        marginLeft: "190px",
                        marginBottom: '30px',
                        backgroundColor: '#0f3d3e',
                        color:'white'
                      }}
                      
                  >
                    Seller
                  </NavLink>
                )}
                <NavLink
                  
                  to={`/buyer/${account.currentAccount}`}
                  className="bg-new w-32 text-white p-2 ml-2 text-center rounded-2xl"
                  style={{
                    marginLeft: "100px",
                    marginBottom: '30px',
                    backgroundColor: '#0f3d3e', 
                    color: 'white'
                  }}
                  //whileHover={{ color: 'magenta' }}
                >
                  Customer
                </NavLink>
              </div>
            </div>
          </div>
          <div className="right w-1/2 h-full flex justify-center items-center"
            // style={{
            //   backgroundColor: 'white',
            //   borderRadius: '30px',
            //   height: '45%',
            //   width: '30%',
            //   marginLeft:'130px'
            // }}
          >
            <img
              className="w-96"
              src="https://res.cloudinary.com/dgy8ybeoy/image/upload/v1659277815/NFTDocket_Hero_mqqvsn.png"
            />
          </div>
        </div>
      </div>
    </>
  );
}

export default Landing;
