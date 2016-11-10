import UIKit


// MARK: Default Implementation BackingViewProvider

extension BackingViewProvider where Self: UIViewController {
    public var backingView: UIView {
        return view
    }
}

extension BackingViewProvider where Self: UIView {
    public var backingView: UIView {
        return self
    }
}


// MARK: Default Implementation StatefulViewController

/// Default implementation of StatefulViewController for UIViewController
extension StatefulViewController {
    
    public var stateMachine: ViewStateMachine {
        return associatedObject(host: self, key: &stateMachineKey) { [unowned self] in
            return ViewStateMachine(view: self.backingView)
        }
    }
    
    public var currentState: StatefulViewControllerState {
        switch stateMachine.currentState {
        case .None: return .Content
        case .View(let viewKey): return StatefulViewControllerState(rawValue: viewKey)!
        }
    }
    
    public var lastState: StatefulViewControllerState {
        switch stateMachine.lastState {
        case .None: return .Content
        case .View(let viewKey): return StatefulViewControllerState(rawValue: viewKey)!
        }
    }
    
    
    // MARK: Views
    
    public var loadingView: UIView? {
        get { return placeholderView(state: .Loading) }
        set { setPlaceholderView(view: newValue, forState: .Loading) }
    }
    
    public var errorView: UIView? {
        get { return placeholderView(state: .Error) }
        set { setPlaceholderView(view: newValue, forState: .Error) }
    }
    
    public var emptyView: UIView? {
        get { return placeholderView(state: .Empty) }
        set { setPlaceholderView(view: newValue, forState: .Empty) }
    }
    
    
    // MARK: Transitions
    
    public func setupInitialViewState(completion: (() -> Void)? = nil) {
        let isLoading = (lastState == .Loading)
        let error: NSError? = (lastState == .Error) ? NSError(domain: "com.aschuch.StatefulViewController.ErrorDomain", code: -1, userInfo: nil) : nil
        transitionViewStates(loading: isLoading, error: error, animated: false, completion: completion)
    }
    
    public func startLoading(animated: Bool = false, completion: (() -> Void)? = nil) {
        transitionViewStates(loading: true, error: nil, animated: animated, completion: completion)
    }
    
    public func endLoading(animated: Bool = true, error: Error? = nil, completion: (() -> Void)? = nil) {
        transitionViewStates(loading: false, error: error, animated: animated, completion: completion)
    }
    
    public func transitionViewStates(loading: Bool = false, error: Error? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
        // Update view for content (i.e. hide all placeholder views)
        if hasContent() {
            if let e = error {
                // show unobstrusive error
                handleErrorWhenContentAvailable(error: e)
            }
            self.stateMachine.transitionToState(state: .None, animated: animated, completion: completion)
            return
        }
        
        // Update view for placeholder
        var newState: StatefulViewControllerState = .Empty
        if loading {
            newState = .Loading
        } else if let _ = error {
            newState = .Error
        }
        self.stateMachine.transitionToState(state: .View(newState.rawValue), animated: animated, completion: completion)
    }
    
    
    // MARK: Content and error handling
    
    public func hasContent() -> Bool {
        return true
    }
    
    public func handleErrorWhenContentAvailable(error: Error) {
        // Default implementation does nothing.
    }
    
    
    // MARK: Helper
    
    private func placeholderView(state: StatefulViewControllerState) -> UIView? {
        return stateMachine[state.rawValue]
    }
    
    private func setPlaceholderView(view: UIView?, forState state: StatefulViewControllerState) {
        stateMachine[state.rawValue] = view
    }
}


// MARK: Association

private var stateMachineKey: UInt8 = 0

private func associatedObject<T: AnyObject>(host: AnyObject, key: UnsafePointer<Void>, initial: () -> T) -> T {
    var value = objc_getAssociatedObject(host, key) as? T
    if value == nil {
        value = initial()
        objc_setAssociatedObject(host, key, value, .OBJC_ASSOCIATION_RETAIN)
    }
    return value!
}
