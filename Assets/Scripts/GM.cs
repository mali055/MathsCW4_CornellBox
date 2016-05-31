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
        public string[] shaderNames;
        public int alexShaders;


        GameObject[] objRefs;
        public GameObject[] objRefs2;

        
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

            objRefs = GameObject.FindGameObjectsWithTag("ChangingShader");

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
                    if (val < alexShaders)
                    {

                        for (int i = 0; i < objRefs2.Length; i++)
                        {
                            objRefs2[i].SetActive(false);
                        }
                        objRefs[0].GetComponent<ObjectController>().SetMaterial(val);
                        objRefs[0].SetActive(false);
                        objRefs[0].SetActive(true);
                        objRefs[1].SetActive(true);
                        objRefs[2].SetActive(true);
                    } else
                    {
                        objRefs[0].SetActive(false);
                        objRefs[1].SetActive(false);
                        objRefs[2].SetActive(false);
                        for (int i = 0; i < objRefs2.Length; i++)
                        {
                            if (i + ((val-alexShaders) * objRefs2.Length) < materials.Length) { 
                                objRefs2[i].GetComponent<Renderer>().material = materials[i + ((val - alexShaders) * objRefs2.Length)];
                                objRefs2[i].SetActive(false);
                                objRefs2[i].SetActive(true);
                            }
                        }
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