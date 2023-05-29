abstract class HomeStates {}

class InitialState extends HomeStates {}

//------------------------------
class LoadingNsehaState extends HomeStates {}

class NasehaSuccessState extends HomeStates {}

class NasehaErrorState extends HomeStates {}
//------------------------------

class SuccessLoadStatialAdState extends HomeStates {}

class ErrorLoadStatialAdState extends HomeStates {}

class SuccessShowStatialAdState extends HomeStates {}

//------------------------------

class SuccessRewardAdLoad extends HomeStates {}

class ErrorRewardAdLoad extends HomeStates {}

class RewardAdShowenState extends HomeStates {}

//------------------------------

class SuccessNavigateState extends HomeStates {}

class ErrorNavigateState extends HomeStates {}

//------------------------------

class CoppySuccessState extends HomeStates {}

class CoppyErrorState extends HomeStates {}

//------------------------------

class LoadingOpenAppAdState extends HomeStates {}

class SuccessOpenAppAdState extends HomeStates {}

class ErrorOpenAppAdState extends HomeStates {}

class IncreaseCounterState extends HomeStates {}
