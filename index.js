import { NativeModules } from 'react-native';


const {NativeUpgrade} = NativeModules;

export const checkForUpdate = NativeUpgrade.checkForUpdate;//检测是否有新版本

export const gotoAppStore = NativeUpgrade.gotoAppStore;