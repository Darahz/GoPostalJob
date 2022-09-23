Config = {}

Config.VehicleOptions = {
    VehicleHash = -233098306,
    VehiclePlate = "gopost",
    VehicleSpawnPos = vector4(60.74, 103.96, 79.04, 158.17)
}

Config.GoPostalJobBlip = {
    location = vector3(61.33, 107.08, 79.07),
    blip = 616,
    color = 21
}

--[[Messages used for blip text and interaction text :
    Deliver    <deliverytype>
    Delivering <deliverytype>
]]--

Config.DeliveryTypes = {
    "mail",
    "news paper",
    "package",
    "bills",
    "magazines",
    "fashion mags",
    "posters",
    "the hottest news",
    "pisswasser poster",
    "slurp n' go ad",
    "glazed and glorious ad",
    "Bikini tow ad",
    "THE package",
    "angel dust",
    "poster with cats",
    "a yellow rat poster",
    "ham and cheese sandwich",
    "Smoke On The Water ad",
    "... 'Stop looking at my mail' mail",
    "OSHA safety tips",
    "Nismos catalog",
    "10-42's menu",
    "Pillbox love letter",
    "Munja Munja's menu",
    "rockford records newest single",
    "Finns taxi prices",
    "Finns taxi tours poster",
    "Bravo's best hair tips",
    "Vanilla Unicorn poster",
    "Open road special menu",
    "Kildare Auto's catalog",
    "Public safety ad",
    "a shopping list",
    "your list of packages",
    "a todo list",
    "a t-shirt of the best kind",
    "a picture of a guy in a tree",
    "a red gang poster",
    "no trivia trivia book"
}

Config.Ped = {
    Model = "s_m_m_postal_02",
    Location = vector4(52.29, 110.02, 78.16, 175.9),
    scenario = 'WORLD_HUMAN_CLIPBOARD'
}


Config.PostalRoutes = {
    zoneOptions = {
        length = 3.0,
        width = 3.0
    },
    GoPostalHQ = vector3(79.3, 97.18, 78.84),
    Jobs = {
        [0] = {
            name = "littleseoul route",
            routes = {
                [0] = {
                    name = "Digital Den",
                    location = vector3(-661.04, -849.68, 24.44)
                },
                [1] = {
                    name = "Housing complex",
                    location = vector3(-752.74, -861.27, 22.34)
                },
                [2] = {
                    name = "Vespucci Canals",
                    location = vector3(-821.57, -994.96, 13.52)
                },
                [3] = {
                    name = "Decker st",
                    location = vector3(-846.28, -855.74, 19.34)
                },
                [4] = {
                    name = "Parking lot Ginger St",
                    location = vector3(-734.77, -744.28, 27.26)
                },
                [5] = {
                    name = "Valdez Cinema",
                    location = vector3(-738.48, -691.09, 30.29)
                },
                [5] = {
                    name = "Fine art school",
                    location = vector3(-711.76, -670.28, 30.49)
                },
                [6] = {
                    name = "Taco bomb",
                    location = vector3(-650.32, -682.31, 31.21)
                },
                [7] = {
                    name = "Hat'n Run",
                    location = vector3(-555.67, -686.6, 33.23)
                },
                [9] = {
                    name = "Weazel News",
                    location = vector3(-617.98, -949.34, 21.66)
                },
                [10] = {
                    name = "GoPostal hq",
                    location = vector3(79.3, 97.18, 78.84)
                }
            }
        },
        [1] = {
            name = "eclipse boulevard",
            routes = {
                [0] = {
                    name = "Haute Restaurant",
                    location = vector4(-40.61, 227.5, 107.97, 261.18)
                },
                [1] = {
                    name = "Hardcore Comic store",
                    location = vector4(-144.0, 229.61, 94.93, 179.13)
                },
                [2] = {
                    name = "Spitroasters Meathouse",
                    location = vector4(-241.91, 279.77, 92.04, 0.75)
                },
                [3] = {
                    name = "Parking lot WC",
                    location = vector4(-327.58, 270.73, 86.46, 280.89)
                },
                [4] = {
                    name = "Skull island",
                    location = vector4(-555.7, 298.05, 83.13, 201.05)
                },
                [5] = {
                    name = "West vinewood 3565",
                    location = vector4(-518.42, 430.23, 96.72, 312.28)
                },
                [6] = {
                    name = "West vinewood 3548",
                    location = vector4(-515.36, 413.25, 97.49, 222.23)
                },
                [7] = {
                    name = "West vinewood 3567",
                    location = vector4(-485.64, 404.51, 99.67, 339.34)
                },
                [8] = {
                    name = "West vinewood 3569",
                    location = vector4(-380.81, 426.11, 109.97, 32.9)
                },
                [9] = {
                    name = "West vinewood 3572",
                    location = vector4(-329.12, 435.13, 109.46, 188.24)
                },
                [10] = {
                    name = "West vinewood 3566",
                    location = vector4(-170.01, 432.2, 111.16, 199.81)
                },
                [11] = {
                    name = "GoPostal hq",
                    location = vector3(79.3, 97.18, 78.84)
                }
            }
        },
        [2] = {
            name = "South Losantos",
            routes = {
                [0] = {
                    name = "B. J Smith",
                    location = vector4(-202.11, -1489.61, 31.45, 51.43)
                },
                [1] = {
                    name = "Chamberlain Hills 1",
                    location = vector4(-208.71, -1600.47, 34.87, 264.22)
                },
                [2] = {
                    name = "Limited LTD",
                    location = vector4(-55.22, -1756.06, 29.44, 324.99)
                },
                [3] = {
                    name = "Davis Ave - Mega Mall",
                    location = vector4(91.29, -1660.83, 29.29, 24.58)
                },
                [4] = {
                    name = "Ron gas station",
                    location = vector4(184.95, -1577.35, 29.29, 209.34)
                },
                [5] = {
                    name = "Hearty Tac<3",
                    location = vector4(438.66, -1466.42, 29.29, 248.75)
                },
                [6] = {
                    name = "Bert's tool supplies",
                    location = vector4(361.07, -1312.77, 32.46, 50.96)
                },
                [7] = {
                    name = "Flower Emporium",
                    location = vector4(307.88, -1286.4, 30.57, 346.9)
                },
                [8] = {
                    name = "Glorias Fashion boutique",
                    location = vector4(199.44, -1268.8, 29.18, 76.91)
                },
                [9] = {
                    name = "Vanilla Unicorn",
                    location = vector4(88.57, -1306.69, 29.29, 124.63)
                },
                [10] = {
                    name = "Glass Heroes",
                    location = vector4(-229.81, -1377.07, 31.26, 29.34)
                },
                [11] = {
                    name = "GoPostal hq",
                    location = vector3(79.3, 97.18, 78.84)
                }
            }
        },
        [3] = {
            name = "Downtown Los Santos",
            routes = {
                [0] = {
                    name = "Daily globe international",
                    location = vector4(-319.51, -610.05, 33.56, 92.81)
                },
                [1] = {
                    name = "Schlongberg Sash",
                    location = vector4(-223.08, -704.09, 33.59, 63.43)
                },
                [2] = {
                    name = "Alta st",
                    location = vector4(-232.98, -972.87, 29.29, 241.53)
                },
                [3] = {
                    name = "Banner: Hotel and spa",
                    location = vector4(-268.6, -1070.92, 25.27, 252.2)
                },
                [4] = {
                    name = "Impound lot",
                    location = vector4(-189.57, -1152.0, 23.04, 180.93)
                },
                [5] = {
                    name = "Hookah Palace",
                    location = vector4(-29.04, -984.22, 29.27, 66.39)
                },
                [6] = {
                    name = "Fleeca bank",
                    location = vector4(152.76, -1041.54, 29.37, 151.07)
                },
                [7] = {
                    name = "J's bonds",
                    location = vector4(361.69, -1067.6, 29.53, 3.76)
                },
                [8] = {
                    name = "Los Santos Police Department",
                    location = vector4(391.84, -1004.1, 29.42, 271.11)
                },
                [9] = {
                    name = "Smoke on the water",
                    location = vector4(357.77, -839.47, 29.29, 174.2)
                },
                [10] = {
                    name = "Pillbox Hill Medical Center",
                    location = vector4(235.15, -604.47, 42.27, 249.95)
                },
                [11] = {
                    name = "GoPostal hq",
                    location = vector3(79.3, 97.18, 78.84)
                }
            }
        },
        [4] = {
            name = "East Los Santos",
            routes = {
                [0] = {
                    name = "Bikini Tow HQ",
                    location = vector4(788.3, -771.43, 26.44, 178.41)
                },
                [1] = {
                    name = "Guns 4 Funs",
                    location = vector4(835.25, -1036.91, 27.65, 279.66)
                },
                [2] = {
                    name = "Soyler Textile",
                    location = vector4(766.67, -1317.7, 27.28, 88.94)
                },
                [3] = {
                    name = "San taqueria",
                    location = vector4(991.95, -1397.06, 31.53, 28.58)
                },
                [4] = {
                    name = "Los santos county : fire department",
                    location = vector4(1170.99, -1464.12, 34.89, 168.48)
                },
                [5] = {
                    name = "L T Weld supply co",
                    location = vector4(1145.66, -1402.17, 34.8, 353.68)
                },
                [6] = {
                    name = "Los santos bag co.",
                    location = vector4(765.01, -1359.0, 27.88, 174.42)
                },
                [7] = {
                    name = "Window Tinting",
                    location = vector4(911.0, -1025.58, 38.21, 272.93)
                },
                [8] = {
                    name = "Mufflers and tires",
                    location = vector4(869.23, -1056.25, 29.44, 274.34)
                },
                [9] = {
                    name = "Liquor Market",
                    location = vector4(807.38, -1073.54, 28.92, 321.89)
                },
                [10] = {
                    name = "Freedom land",
                    location = vector4(838.72, -846.55, 26.38, 226.0)
                },
                [11] = {
                    name = "GoPostal hq",
                    location = vector3(79.3, 97.18, 78.84)
                }
            }
        },
        [5] = {
            name = "Rockford Hills",
            routes = {
                [0] = {
                    name = "West vinewood 548",
                    location = vector4(-323.05, 133.89, 67.38, 359.7)
                },
                [1] = {
                    name = "West vinewood 527",
                    location = vector4(-524.29, 119.94, 63.12, 351.58)
                },
                [2] = {
                    name = "The Epsilon Program villa",
                    location = vector4(-698.87, 47.44, 44.03, 24.67)
                },
                [3] = {
                    name = "Maracas",
                    location = vector4(-777.48, -139.12, 37.79, 113.49)
                },
                [4] = {
                    name = "Johnny's saloon",
                    location = vector4(-726.15, -151.89, 37.14, 281.77)
                },
                [5] = {
                    name = "Persues clothing store",
                    location = vector4(-666.68, -329.09, 35.2, 122.26)
                },
                [6] = {
                    name = "Rockford Dorset",
                    location = vector4(-558.43, -387.41, 35.08, 0.09)
                },
                [7] = {
                    name = "City Hall",
                    location = vector4(-528.64, -266.33, 35.42, 298.51)
                },
                [8] = {
                    name = "Harper unit for clinical psychology",
                    location = vector4(-399.9, -316.57, 35.14, 142.78)
                },
                [9] = {
                    name = "Rockford Plaza",
                    location = vector4(-233.77, -332.24, 30.09, 276.85)
                },
                [10] = {
                    name = "Los Santos Customs",
                    location = vector4(-355.31, -144.11, 42.74, 302.35)
                },
                [11] = {
                    name = "GoPostal hq",
                    location = vector3(79.3, 97.18, 78.84)
                }
            }
        },
    }
}