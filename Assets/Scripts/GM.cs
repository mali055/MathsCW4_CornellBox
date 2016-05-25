//----------------------------------------
//		Unity3D Games Template (C#)
// Copyright © 2015 Lord Meshadieme
// 	   skype : lord_meshadieme
//----------------------------------------

/// <summary>
/// Singleton Referenced gameManager
/// This is the script you reference to get any
/// other sort of information from outside the 
/// particular script you are in. Example usage below.
/// <example>
/// GM.Get().someVariableOrFunctionHere.
/// </example>
/// </summary>

//Imports
using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;
using Meshadieme;

namespace Meshadieme
{

    public class GM : MonoBehaviour
    {
        

        static GM gameManager; //Static GameManager Object (accessible by all)
        
        public bool readyScene = false;
        public GameObject[] buttonRefs;
        public GameObject[] objRefs;
        public string[] shaderNames;
        public Material[] materials;

        /// <summary>
        /// Get (Utility) function
        /// On callBack function for other scripts to reference theGameManager.
        /// </summary>
        public static GM Get()
        {
            return gameManager;
        }


        /// <summary>
        /// Awake (Unity) function
        /// This is called FIRST, you may have to increase priority to load this in the Script Execution Order
        /// </summary>
        void Awake()
        {
            Debug.Log("GM_Awake()");
            gameManager = GetComponent<GM>() as GM;

            //Fill Drop downs
            //Shaders
            List<Dropdown.OptionData> list = new List<Dropdown.OptionData>();
            for (int i =0; i < shaderNames.Length; i++ )
            {
                list.Add(new Dropdown.OptionData(shaderNames[i]));
            }
            buttonRefs[0].GetComponent<Dropdown>().options = list;
            //Lights?
        }

        public int getButtonIndex(GameObject gObj)
        {
            return System.Array.IndexOf(buttonRefs, gObj);
        }

        public void inputProcessing(GameObject go)
        {
            int index = getButtonIndex(go);
            Debug.Log("GM_InputProc() = " + go + "(" + index + ")");

            switch ( index )
            {
                case 0://Drop Shader

                    break;
                case 1: //Apply Shader
                    int val = buttonRefs[0].GetComponent<Dropdown>().value;
                    for (int i = 0; i < objRefs.Length; i++)
                    {
                        objRefs[i].GetComponent<Renderer>().material = materials[i + (val * objRefs.Length)];
                        objRefs[i].SetActive(false);
                        objRefs[i].SetActive(true);
                    }
                    break;
                case 2: //Drop Light

                    break;
                case 3: //Apply Light
                    
                    break;
                case 4: //Transparency Slider

                    break;
            }
        }

    }
}